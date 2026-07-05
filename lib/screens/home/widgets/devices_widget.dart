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
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/device_type.dart';
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
      error: (error, _) => RefreshIndicator(
        onRefresh: ref.read(homeServiceProvider.notifier).refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [ErrorMessageView(message: error.toString())],
        ),
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
                    96,
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: state.visibleDevices.length,
                    itemBuilder: (context, index) {
                      final device = state.visibleDevices[index];
                      return MiniHomeDeviceCard(
                        name:
                            device.name ?? device.nickname ?? AppStrings.device,
                        icon: device.type == DeviceType.light
                            ? Icons.lightbulb_outline_rounded
                            : Icons.air_rounded,
                        status: device.isOnline
                            ? AppStrings.online
                            : AppStrings.offline,
                        detail: _detail(device),
                        isPowerOn: device.isPowerOn,
                        isOnline: device.isOnline,
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
      DeviceType.light =>
        AppStrings.brightnessValue(device.lightState?.brightness ?? 0),
      DeviceType.airConditioner => AppStrings.temperatureValue(
          device.airConditionerState?.targetTemperature ?? 24,
        ),
    };
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
