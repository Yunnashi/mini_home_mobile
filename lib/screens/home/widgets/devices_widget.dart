import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/core/widgets/mini_home_device_card.dart';
import 'package:mini_home/core/widgets/mini_home_empty_state.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/device/models/air_conditioner_state.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/device_type.dart';
import 'package:mini_home/features/home/models/home_summary.dart';
import 'package:mini_home/features/home/services/home_service.dart';
import 'package:mini_home/router/router.dart';

class DevicesWidget extends HookConsumerWidget {
  const DevicesWidget(
    this.authState, {
    super.key,
    this.onLeftWidgetChanged,
  });

  final AuthState authState;
  final ValueChanged<Widget?>? onLeftWidgetChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(homeServiceProvider);

    return dashboard.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => RefreshIndicator(
        onRefresh: ref.read(homeServiceProvider.notifier).refresh,
        child: ErrorMessageView(message: AppStrings.deviceListFetchError),
      ),
      data: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onLeftWidgetChanged?.call(
            Text(
              state.home.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          );
        });

        return RefreshIndicator(
          onRefresh: ref.read(homeServiceProvider.notifier).refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _HomeSummary(
                  devices: state.devices,
                  summary: state.home.summary,
                ),
              ),
              const SliverToBoxAdapter(child: _DeviceSectionHeader()),
              SliverToBoxAdapter(
                child: _RoomFilters(
                  selectedRoomId: state.selectedRoomId,
                  rooms: state.home.rooms
                      .map((room) => (id: room.id, name: room.name))
                      .toList(),
                  onSelected: ref.read(homeServiceProvider.notifier).selectRoom,
                ),
              ),
              if (state.visibleDevices.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: MiniHomeEmptyState(
                    title: AppStrings.noDevicesTitle,
                    message: AppStrings.noDevicesMessage,
                    actionLabel: AppStrings.addDevice,
                    onAction: () => context.pushNamed(
                      AppRoutes.deviceRegistration,
                      extra: authState,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    24,
                  ),
                  sliver: SliverList.separated(
                    itemCount: state.visibleDevices.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final device = state.visibleDevices[index];
                      final isAir = device.type == DeviceType.airConditioner;
                      return MiniHomeDeviceCard(
                        name:
                            device.name ?? device.nickname ?? AppStrings.device,
                        icon: isAir
                            ? Icons.air_rounded
                            : Icons.lightbulb_outline_rounded,
                        roomName: _roomName(state, device.roomId),
                        status: device.isOnline
                            ? AppStrings.online
                            : AppStrings.offline,
                        detail: _detail(device),
                        isPowerOn: device.isPowerOn,
                        isOnline: device.isOnline,
                        iconColor: isAir
                            ? AppColors.airConditioner
                            : AppColors.primary,
                        iconBackgroundColor: isAir
                            ? AppColors.lightGreen
                            : AppColors.primaryContainer,
                        infoPills: _infoPills(device),
                        onTap: () => context.pushNamed(
                          AppRoutes.deviceDetail,
                          pathParameters: {'deviceId': '${device.id}'},
                        ),
                        onPowerChanged: (value) async {
                          try {
                            await ref
                                .read(homeServiceProvider.notifier)
                                .togglePower(device, value);
                          } catch (_) {
                            if (context.mounted) {
                              BasicToast.showToast(
                                AppStrings.deviceDetailUpdateError,
                                ToastType.error,
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String? _detail(Device device) {
    return switch (device.type) {
      DeviceType.light => '${device.lightState?.brightness ?? 0}%',
      DeviceType.airConditioner => AppStrings.temperatureValue(
          device.airConditionerState?.targetTemperature ?? 24,
        ),
    };
  }

  String _roomName(HomeDashboardState state, int roomId) {
    for (final room in state.home.rooms) {
      if (room.id == roomId) return room.name;
    }
    return AppStrings.room;
  }

  List<MiniHomeDeviceInfoPill> _infoPills(Device device) {
    final airState = device.airConditionerState;
    return switch (device.type) {
      DeviceType.light => [
          MiniHomeDeviceInfoPill(
            icon: Icons.thermostat_rounded,
            label: _colorTemperatureLabel(
              device.lightState?.colorTemperature,
            ),
          ),
        ],
      DeviceType.airConditioner => [
          MiniHomeDeviceInfoPill(
            icon: Icons.air_rounded,
            label: _modeLabel(airState?.mode),
          ),
          MiniHomeDeviceInfoPill(
            icon: Icons.mode_fan_off_outlined,
            label: _fanLabel(airState?.fanSpeed),
          ),
        ],
    };
  }

  String _colorTemperatureLabel(int? value) {
    if (value == null) return '--';
    final preset = value < 3500
        ? AppStrings.warmLight
        : value < 5200
            ? AppStrings.neutralLight
            : AppStrings.coolLight;
    return '$preset · ${value}K';
  }

  String _modeLabel(AirConditionerMode? mode) => switch (mode) {
        AirConditionerMode.auto => AppStrings.autoMode,
        AirConditionerMode.cooling => AppStrings.coolingMode,
        AirConditionerMode.heating => AppStrings.heatingMode,
        AirConditionerMode.fan => AppStrings.fanMode,
        null => '--',
      };

  String _fanLabel(FanSpeed? speed) => switch (speed) {
        FanSpeed.auto => AppStrings.autoMode,
        FanSpeed.low => AppStrings.lowFan,
        FanSpeed.medium => AppStrings.mediumFan,
        FanSpeed.high => AppStrings.highFan,
        null => '--',
      };
}

class _HomeSummary extends StatelessWidget {
  const _HomeSummary({
    required this.devices,
    required this.summary,
  });

  final List<Device> devices;
  final HomeSummary? summary;

  @override
  Widget build(BuildContext context) {
    final fallbackActiveCount =
        devices.where((device) => device.isOnline && device.isPowerOn).length;
    final activeCount = summary?.activeDeviceCount ?? fallbackActiveCount;
    final indoorTemperature = summary?.indoorTemperature;
    final todayEnergyKwh = summary?.todayEnergyKwh;

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          _SummaryChip(
            icon: Icons.bolt_rounded,
            label: AppStrings.activeDevices(activeCount),
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          _SummaryChip(
            icon: Icons.thermostat_rounded,
            label: indoorTemperature == null
                ? '--'
                : AppStrings.indoorTemperature(indoorTemperature),
            color: AppColors.secondary,
          ),
          if (todayEnergyKwh != null) ...[
            const SizedBox(width: AppSpacing.xs),
            _SummaryChip(
              icon: Icons.energy_savings_leaf_rounded,
              label: AppStrings.todayEnergy(todayEnergyKwh),
              color: AppColors.airConditioner,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}

class _DeviceSectionHeader extends StatelessWidget {
  const _DeviceSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Text(
            AppStrings.deviceTab,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            AppStrings.groupTab,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _RoomFilters extends StatelessWidget {
  const _RoomFilters({
    required this.selectedRoomId,
    required this.rooms,
    required this.onSelected,
  });

  final int? selectedRoomId;
  final List<({int id, String name})> rooms;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final room = isAll ? null : rooms[index - 1];
          return ChoiceChip(
            label: Text(isAll ? AppStrings.allRooms : room!.name),
            selected:
                isAll ? selectedRoomId == null : selectedRoomId == room!.id,
            onSelected: (_) => onSelected(room?.id),
            selectedColor: AppColors.primaryContainer,
            side: const BorderSide(color: AppColors.border),
          );
        },
      ),
    );
  }
}
