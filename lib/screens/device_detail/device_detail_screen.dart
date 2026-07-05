import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/features/device/models/air_conditioner_state.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/device_type.dart';
import 'package:mini_home/features/device/models/light_state.dart';
import 'package:mini_home/features/device/services/smart_device_service.dart';

class DeviceDetailScreen extends HookConsumerWidget {
  const DeviceDetailScreen({required this.deviceId, super.key});

  final int deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(smartDeviceServiceProvider(deviceId));
    final service = ref.read(smartDeviceServiceProvider(deviceId).notifier);

    Future<void> guard(Future<void> Function() action) async {
      try {
        await action();
      } catch (_) {
        BasicToast.showToast(
            AppStrings.deviceDetailUpdateError, ToastType.error);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(device.value?.name ?? AppStrings.deviceDetailTitle),
        actions: [
          IconButton(
            onPressed: () => context.push('/device-detail/$deviceId/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: device.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => RefreshIndicator(
          onRefresh: service.refresh,
          child: ListView(children: [ErrorMessageView(message: '$error')]),
        ),
        data: (value) => RefreshIndicator(
          onRefresh: service.refresh,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _DeviceHero(
                device: value,
                onPowerChanged: (power) => guard(() => service.setPower(power)),
              ),
              if (!value.isOnline) ...[
                const SizedBox(height: AppSpacing.md),
                _OfflineBanner(message: AppStrings.offlineMessage),
              ],
              const SizedBox(height: AppSpacing.md),
              switch (value.type) {
                DeviceType.light => _LightControlPanel(
                    device: value,
                    onChanged: (state) =>
                        guard(() => service.setLightState(state)),
                  ),
                DeviceType.airConditioner => _AirConditionerControlPanel(
                    device: value,
                    onChanged: (state) =>
                        guard(() => service.setAirConditionerState(state)),
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceHero extends StatelessWidget {
  const _DeviceHero({required this.device, required this.onPowerChanged});

  final Device device;
  final ValueChanged<bool> onPowerChanged;

  @override
  Widget build(BuildContext context) {
    final active = device.isOnline && device.isPowerOn;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryContainer : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            device.type == DeviceType.light
                ? Icons.lightbulb_rounded
                : Icons.air_rounded,
            size: 64,
            color: active ? AppColors.primary : AppColors.greyText,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppStrings.power),
              Switch.adaptive(
                value: device.isPowerOn,
                onChanged: device.isOnline ? onPowerChanged : null,
              ),
            ],
          ),
        ],
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
    return _Panel(
      enabled: device.isOnline && device.isPowerOn,
      children: [
        _SliderControl(
          label: AppStrings.brightness,
          value: state.brightness.toDouble(),
          min: 0,
          max: 100,
          suffix: '${state.brightness}%',
          onChanged: (value) =>
              onChanged(state.copyWith(brightness: value.round())),
        ),
        _SliderControl(
          label: AppStrings.colorTemperature,
          value: state.colorTemperature.toDouble(),
          min: 2700,
          max: 6500,
          divisions: 38,
          suffix: '${state.colorTemperature} K',
          onChanged: (value) =>
              onChanged(state.copyWith(colorTemperature: value.round())),
        ),
      ],
    );
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
    return _Panel(
      enabled: device.isOnline && device.isPowerOn,
      children: [
        _SliderControl(
          label: AppStrings.targetTemperature,
          value: state.targetTemperature.toDouble(),
          min: 16,
          max: 30,
          divisions: 14,
          suffix: '${state.targetTemperature} °C',
          onChanged: (value) =>
              onChanged(state.copyWith(targetTemperature: value.round())),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.operationMode),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: AirConditionerMode.values.map((mode) {
            return ChoiceChip(
              label: Text(_modeLabel(mode)),
              selected: state.mode == mode,
              onSelected: (_) => onChanged(state.copyWith(mode: mode)),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.fanSpeed),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: FanSpeed.values.map((speed) {
            return ChoiceChip(
              label: Text(_fanLabel(speed)),
              selected: state.fanSpeed == speed,
              onSelected: (_) => onChanged(state.copyWith(fanSpeed: speed)),
            );
          }).toList(),
        ),
      ],
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

class _Panel extends StatelessWidget {
  const _Panel({required this.enabled, required this.children});

  final bool enabled;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.45,
        duration: const Duration(milliseconds: 180),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.panel),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _SliderControl extends StatelessWidget {
  const _SliderControl({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String suffix;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(suffix)],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
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
        color: AppColors.background,
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
