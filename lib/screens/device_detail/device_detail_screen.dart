import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/app_dropdown_field.dart';
import 'package:mini_home/core/widgets/app_offline_banner.dart';
import 'package:mini_home/core/widgets/app_slider_control_card.dart';
import 'package:mini_home/core/widgets/app_status_pill.dart';
import 'package:mini_home/core/widgets/app_surface_card.dart';
import 'package:mini_home/core/widgets/app_value_control_card.dart';
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
    final lifecycle = useAppLifecycleState();
    final pollingTimer = useRef<Timer?>(null);

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

    Future<void> refreshDeviceSilently() async {
      try {
        await service.refresh(showLoading: false);
      } catch (_) {
        // Polling should stay quiet; pull-to-refresh and user actions show UI errors.
      }
    }

    void stopPolling() {
      pollingTimer.value?.cancel();
      pollingTimer.value = null;
    }

    void startPolling() {
      stopPolling();
      pollingTimer.value = Timer.periodic(const Duration(seconds: 30), (_) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
        unawaited(refreshDeviceSilently());
      });
    }

    useEffect(() {
      if (lifecycle == AppLifecycleState.resumed) {
        if (device.hasValue) {
          unawaited(refreshDeviceSilently());
        }
        startPolling();
      } else {
        stopPolling();
      }
      return stopPolling;
    }, [lifecycle, deviceId]);

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
                      AppOfflineBanner(message: AppStrings.offlineMessage),
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
        AppStatusPill(
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
          AppSliderControlCard(
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
          AppDropdownControlCard<int>(
            icon: Icons.thermostat_rounded,
            title: AppStrings.colorTemperature,
            value: _colorTemperaturePreset(state.colorTemperature),
            compact: true,
            items: [
              AppDropdownOption(
                value: 3000,
                label: '${AppStrings.warmLight} · 3000K',
              ),
              AppDropdownOption(
                value: 4500,
                label: '${AppStrings.neutralLight} · 4500K',
              ),
              AppDropdownOption(
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
          AppValueControlCard(
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
                child: AppDropdownControlCard<AirConditionerMode>(
                  icon: Icons.mode_fan_off_outlined,
                  title: AppStrings.operationMode,
                  value: state.mode,
                  compact: true,
                  items: AirConditionerMode.values
                      .map(
                        (mode) => AppDropdownOption(
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
                child: AppDropdownControlCard<FanSpeed>(
                  icon: Icons.air_rounded,
                  title: AppStrings.fanSpeed,
                  value: state.fanSpeed,
                  compact: true,
                  items: FanSpeed.values
                      .map(
                        (speed) => AppDropdownOption(
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

    return AppSurfaceCard(
      radius: 32,
      padding: EdgeInsets.zero,
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
