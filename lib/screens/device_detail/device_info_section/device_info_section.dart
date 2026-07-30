import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/skeleton.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/services/device_service.dart';
import 'package:mini_home/screens/device_detail/device_info_section/widgets/device_charging_ampere_info_widget.dart';
import 'package:mini_home/screens/device_detail/device_info_section/widgets/device_image_widget.dart';
import 'package:mini_home/screens/device_detail/device_info_section/widgets/device_card.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/features/device/repositories/charging_ampere_storage_repository.dart';
import 'package:mini_home/screens/device_detail/dialogs/charging_ampere_edit_dialog.dart';
import 'package:mini_home/utils/logger.dart';

class DeviceInfoSection extends StatelessWidget {
  final BuildContext context;
  final WidgetRef ref;
  final int? userGroupId;
  final ValueNotifier<Device?> device;
  final ValueNotifier<double?> pendingChargingAmpere;
  final ValueNotifier<double> selectedChargingKW;
  final bool isLoading;

  const DeviceInfoSection({
    super.key,
    required this.context,
    required this.ref,
    required this.userGroupId,
    required this.device,
    required this.pendingChargingAmpere,
    required this.selectedChargingKW,
    this.isLoading = false,
  });

  Future<void> onSaveChargingAmpereChange() async {
    if (userGroupId == null || device.value == null) {
      safeDebugPrint("[ERROR] User group or device information is null");
      BasicDialog.showError(
          context: context, errorMessage: AppStrings.deviceDetailUpdateError);
      return;
    }
    final double chargingAmpere = selectedChargingKW.value.toAmpere();
    await ref.read(deviceServiceProvider.notifier).updateChargingAmpere(
          userGroupId: userGroupId!,
          deviceId: device.value!.id,
          chargingAmpere: chargingAmpere,
          successCallback: () async {
            pendingChargingAmpere.value = chargingAmpere;
            await ChargingAmpereStorage.set(device.value!.id, chargingAmpere);
            GoRouter.of(context).pop();
          },
          errorCallback: (msg, code) {
            GoRouter.of(context).pop();
            BasicDialog.showError(
                context: context, errorMessage: msg, errorCode: code);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 充電器画像＋出力変更
        if (isLoading)
          const SizedBox(height: 232)
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Stack(
              children: [
                const SizedBox(height: 220),
                DeviceImageWidget(
                  deviceType: device.value!.type,
                  statusColor: device.value!.status.color,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: DeviceChargingAmpereInfoWidget(
                    device: device.value!,
                    pendingChargingAmpere: pendingChargingAmpere.value,
                    onSaveChargingAmpereChange: (context) async {
                      final maxAmp = device.value!.maxChargingAmpere ?? 30;
                      if (device.value!.isOffline) {
                        BasicDialog.showError(
                            context: context,
                            errorMessage: AppStrings.deviceIsOfflineError);
                        return;
                      }
                      showChargingAmpereEditDialog(
                        context: context,
                        maxChargingAmpere: maxAmp,
                        selectedChargingKW: selectedChargingKW,
                        onSave: () async {
                          await onSaveChargingAmpereChange();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        // 充電器の情報カード
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.deviceInfo, style: AppTextStyle.body1),
            const SizedBox(height: 8),
            if (isLoading)
              const Skeleton(height: 110)
            else
              DeviceCard(
                device: device.value!,
                pendingChargingAmpere: pendingChargingAmpere.value,
              ),
            const SizedBox(height: 16),
          ],
        )
      ],
    );
  }
}
