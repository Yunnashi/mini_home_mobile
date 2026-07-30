import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/features/device/models/air_conditioner_state.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/device_type.dart';
import 'package:mini_home/features/device/models/light_state.dart';
import 'package:mini_home/features/device/services/smart_device_service.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:mini_home/features/schedule/services/schedule_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/screens/device_detail/schedule_section/schedule_section.dart';

class DeviceDetailScreen extends HookConsumerWidget {
  const DeviceDetailScreen({required this.deviceId, super.key});

  final int deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(smartDeviceServiceProvider(deviceId));
    final service = ref.read(smartDeviceServiceProvider(deviceId).notifier);
    final scheduleListAsync =
        useState<AsyncValue<List<Schedule>>>(const AsyncLoading());

    Future<void> guard(Future<void> Function() action) async {
      try {
        await action();
      } catch (_) {
        BasicToast.showToast(
          AppStrings.deviceDetailUpdateError,
          ToastType.error,
        );
      }
    }

    Future<void> fetchScheduleList(int homeId, int targetDeviceId) async {
      scheduleListAsync.value = const AsyncLoading();
      await ref.read(scheduleServiceProvider.notifier).getSchedulesByDevice(
            homeId: homeId,
            deviceId: targetDeviceId,
            successCallback: (schedules) {
              if (!context.mounted) return;
              scheduleListAsync.value = AsyncData(schedules);
            },
            errorCallback: (message, _) {
              if (!context.mounted) return;
              scheduleListAsync.value = AsyncError(
                  message ?? 'Schedule list error', StackTrace.current);
            },
          );
    }

    Future<void> updateScheduleEnabled({
      required int homeId,
      required int deviceId,
      required Schedule schedule,
      required bool isEnabled,
    }) async {
      await ref.read(scheduleServiceProvider.notifier).toggleScheduleEnabled(
            homeId: homeId,
            deviceId: deviceId,
            scheduleId: schedule.id,
            isEnabled: isEnabled,
            successCallback: (_) async {
              await fetchScheduleList(homeId, deviceId);
            },
            errorCallback: (_, __) {
              BasicToast.showToast(
                AppStrings.deviceDetailUpdateError,
                ToastType.error,
              );
            },
          );
    }

    useEffect(() {
      final value = device.value;
      if (value == null) return null;
      Future.microtask(() async {
        await fetchScheduleList(value.homeId, value.id);
      });
      return null;
    }, [device.value?.id]);

    return BasicScreen(
      backgroundColor: AppColors.background,
      appBar: BasicAppBar.buildPushStyleWithAction(
        context: context,
        titleAppBar: device.value?.name ??
            device.value?.nickname ??
            AppStrings.deviceDetailTitle,
        backgroundColor: AppColors.background,
        rightIcon: IconButton(
          onPressed: () => context.pushNamed(
            AppRoutes.deviceSetting,
            pathParameters: {'deviceId': '$deviceId'},
          ),
          icon: const Icon(Icons.more_horiz_rounded, size: 30),
        ),
      ),
      body: device.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => RefreshIndicator(
          onRefresh: service.refresh,
          child: ErrorMessageView(
            message: AppStrings.deviceDetailFetchError,
          ),
        ),
        data: (value) {
          final isOffline = _isDeviceOffline(value);

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: service.refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    124,
                  ),
                  children: [
                    _DeviceHero(device: value),
                    if (isOffline) ...[
                      const SizedBox(height: AppSpacing.md),
                      _OfflineBanner(message: AppStrings.offlineMessage),
                    ],
                    SizedBox(
                      height: value.type == DeviceType.light
                          ? AppSpacing.md
                          : AppSpacing.lg,
                    ),
                    switch (value.type) {
                      DeviceType.light => _LightControlPanel(
                          device: value,
                          onChanged: (state) =>
                              guard(() => service.setLightState(state)),
                        ),
                      DeviceType.airConditioner => _AirConditionerControlPanel(
                          device: value,
                          onChanged: (state) => guard(
                              () => service.setAirConditionerState(state)),
                        ),
                    },
                    SizedBox(
                      height: value.type == DeviceType.light
                          ? AppSpacing.md
                          : AppSpacing.lg,
                    ),
                    ScheduleSection(
                      context: context,
                      ref: ref,
                      homeId: value.homeId,
                      device: ValueNotifier(value),
                      scheduleListAsync: scheduleListAsync.value,
                      fetchScheduleList: fetchScheduleList,
                      updateScheduleEnabled: updateScheduleEnabled,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: _FloatingActionBar(
                  device: value,
                  deviceId: deviceId,
                  onPowerChanged: (power) =>
                      guard(() => service.setPower(power)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

bool _isDeviceOffline(Device device) => device.isOffline || !device.isOnline;

class _DeviceHero extends StatelessWidget {
  const _DeviceHero({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final isOffline = _isDeviceOffline(device);
    final active = !isOffline && device.isPowerOn;
    final icon =
        device.type == DeviceType.light ? Icons.lightbulb_rounded : Icons.air;
    final isLight = device.type == DeviceType.light;
    final iconContainerSize = isLight ? 116.0 : 132.0;
    final iconSize = isLight ? 66.0 : 78.0;

    return Column(
      children: [
        _StatusPill(
          label: isOffline
              ? AppStrings.offline
              : active
                  ? AppStrings.working
                  : AppStrings.deviceStatusDisconnected,
          active: active,
        ),
        SizedBox(height: isLight ? AppSpacing.md : AppSpacing.lg),
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(36),
            boxShadow: AppShadows.card,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: active ? AppColors.primary : AppColors.greyText,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              size: 9,
              color: active ? AppColors.green : AppColors.placeholder,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _LightControlPanel extends StatelessWidget {
  const _LightControlPanel({required this.device, required this.onChanged});

  final Device device;
  final ValueChanged<LightState> onChanged;

  @override
  Widget build(BuildContext context) {
    final state = device.lightState ?? const LightState();
    final enabled = !_isDeviceOffline(device) && device.isPowerOn;

    return _DisabledSection(
      enabled: enabled,
      child: Column(
        children: [
          _SliderControlCard(
            title: AppStrings.brightness,
            value: state.brightness.toDouble(),
            min: 0,
            max: 100,
            suffix: '%',
            compact: true,
            onChanged: (value) =>
                onChanged(state.copyWith(brightness: value.round())),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DropdownControlCard<int>(
            icon: Icons.thermostat_rounded,
            title: AppStrings.colorTemperature,
            value: _colorTemperaturePreset(state.colorTemperature),
            compact: true,
            items: [
              _DropdownOption(
                value: 3000,
                label: '${AppStrings.warmLight} · 3000K',
              ),
              _DropdownOption(
                value: 4500,
                label: '${AppStrings.neutralLight} · 4500K',
              ),
              _DropdownOption(
                value: 6500,
                label: '${AppStrings.coolLight} · 6500K',
              ),
            ],
            onChanged: (value) =>
                onChanged(state.copyWith(colorTemperature: value)),
          ),
        ],
      ),
    );
  }

  int _colorTemperaturePreset(int value) {
    if (value < 3500) return 3000;
    if (value < 5200) return 4500;
    return 6500;
  }
}

class _AirConditionerControlPanel extends StatelessWidget {
  const _AirConditionerControlPanel({
    required this.device,
    required this.onChanged,
  });

  final Device device;
  final ValueChanged<AirConditionerState> onChanged;

  @override
  Widget build(BuildContext context) {
    final state = device.airConditionerState ?? const AirConditionerState();
    final enabled = !_isDeviceOffline(device) && device.isPowerOn;

    return _DisabledSection(
      enabled: enabled,
      child: Column(
        children: [
          _ValueControlCard(
            value: '${state.targetTemperature}',
            suffix: '°C',
            compact: true,
            onDecrease: () => onChanged(
              state.copyWith(
                targetTemperature:
                    (state.targetTemperature - 1).clamp(16, 30).toInt(),
              ),
            ),
            onIncrease: () => onChanged(
              state.copyWith(
                targetTemperature:
                    (state.targetTemperature + 1).clamp(16, 30).toInt(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _DropdownControlCard<AirConditionerMode>(
                  icon: Icons.mode_fan_off_outlined,
                  title: AppStrings.operationMode,
                  value: state.mode,
                  compact: true,
                  items: AirConditionerMode.values
                      .map(
                        (mode) => _DropdownOption(
                          value: mode,
                          label: _modeLabel(mode),
                        ),
                      )
                      .toList(),
                  onChanged: (mode) => onChanged(state.copyWith(mode: mode)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DropdownControlCard<FanSpeed>(
                  icon: Icons.air_rounded,
                  title: AppStrings.fanSpeed,
                  value: state.fanSpeed,
                  compact: true,
                  items: FanSpeed.values
                      .map(
                        (speed) => _DropdownOption(
                          value: speed,
                          label: _fanLabel(speed),
                        ),
                      )
                      .toList(),
                  onChanged: (speed) =>
                      onChanged(state.copyWith(fanSpeed: speed)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _modeLabel(AirConditionerMode mode) => switch (mode) {
        AirConditionerMode.auto => AppStrings.autoMode,
        AirConditionerMode.cooling => AppStrings.coolingMode,
        AirConditionerMode.heating => AppStrings.heatingMode,
        AirConditionerMode.fan => AppStrings.fanMode,
      };

  String _fanLabel(FanSpeed speed) => switch (speed) {
        FanSpeed.auto => AppStrings.autoMode,
        FanSpeed.low => AppStrings.lowFan,
        FanSpeed.medium => AppStrings.mediumFan,
        FanSpeed.high => AppStrings.highFan,
      };
}

class _DisabledSection extends StatelessWidget {
  const _DisabledSection({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.42,
        duration: const Duration(milliseconds: 180),
        child: child,
      ),
    );
  }
}

class _ValueControlCard extends StatelessWidget {
  const _ValueControlCard({
    required this.value,
    required this.suffix,
    required this.onDecrease,
    required this.onIncrease,
    this.compact = false,
  });

  final String value;
  final String suffix;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      padding: compact
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            )
          : const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RoundControlButton(
            icon: Icons.remove,
            onTap: onDecrease,
            compact: compact,
          ),
          Expanded(
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                        fontSize: compact ? 32 : null,
                      ),
                  children: [
                    TextSpan(text: value),
                    TextSpan(
                      text: suffix,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _RoundControlButton(
            icon: Icons.add,
            onTap: onIncrease,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _RoundControlButton extends StatelessWidget {
  const _RoundControlButton({
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        minimumSize: compact ? const Size.square(40) : null,
        padding: compact ? const EdgeInsets.all(AppSpacing.xs) : null,
      ),
      icon: Icon(icon),
    );
  }
}

class _SliderControlCard extends StatelessWidget {
  const _SliderControlCard({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
    this.compact = false,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final roundedValue = value.round();

    return _SurfaceCard(
      padding: compact
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            )
          : const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                '$roundedValue$suffix',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _DropdownOption<T> {
  const _DropdownOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class _DropdownControlCard<T> extends StatelessWidget {
  const _DropdownControlCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final T value;
  final List<_DropdownOption<T>> items;
  final ValueChanged<T> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      padding: compact
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            )
          : const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.greyText),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? AppSpacing.xxs : AppSpacing.xs),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              isDense: compact,
              borderRadius: BorderRadius.circular(AppRadius.card),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w800,
                  ),
              items: [
                for (final item in items)
                  DropdownMenuItem<T>(
                    value: item.value,
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value == null) return;
                onChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }
}

class _FloatingActionBar extends StatelessWidget {
  const _FloatingActionBar({
    required this.device,
    required this.deviceId,
    required this.onPowerChanged,
  });

  final Device device;
  final int deviceId;
  final ValueChanged<bool> onPowerChanged;

  @override
  Widget build(BuildContext context) {
    final isOffline = _isDeviceOffline(device);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FloatingActionItem(
              icon: Icons.power_settings_new_rounded,
              label:
                  device.isPowerOn ? AppStrings.powerOn : AppStrings.powerOff,
              active: device.isPowerOn && !isOffline,
              onTap: isOffline ? null : () => onPowerChanged(!device.isPowerOn),
            ),
            _FloatingActionItem(
              icon: Icons.history_rounded,
              label: AppStrings.usageHistoryTitle,
              active: false,
              onTap: () => context.pushNamed(
                AppRoutes.usages,
                pathParameters: {'deviceId': '$deviceId'},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingActionItem extends StatelessWidget {
  const _FloatingActionItem({
    required this.icon,
    required this.label,
    required this.active,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  active ? AppColors.primary : AppColors.primaryContainer,
              child: Icon(
                icon,
                color: onTap == null
                    ? AppColors.greyText
                    : active
                        ? AppColors.whiteText
                        : AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: onTap == null ? AppColors.greyText : AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, color: AppColors.greyText),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
