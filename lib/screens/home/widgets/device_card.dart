import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/device_status_badge.dart';
import 'package:mini_home/core/widgets/pending_changes_badge.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/themes/images.dart';

class DeviceCard extends ConsumerWidget {
  final Device device;
  final VoidCallback? onTap;
  final double? pendingChargingAmpere;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
    this.pendingChargingAmpere,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isPending = pendingChargingAmpere != null && device.chargingKw != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.51),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              device.nickname ?? AppStrings.device,
              style: AppTextStyle.body1,
            ),
            // デバイスのID
            Text(
              device.externalDeviceId,
              style: AppTextStyle.body4TextGrey,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // model別icon
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      device.model.getIconPath(ref.watch(appImagesProvider)),
                      width: 32,
                      height: 44,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DeviceStatusBadge(
                        deviceStatus: device.status,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          if (isPending) ...[
                            const PendingChangesBadge(),
                            const SizedBox(width: 5),
                          ],
                          Text(AppStrings.formatDouble(device.chargingKw ?? 0),
                              style: AppTextStyle.body1),
                          Text(
                              "kW (${AppStrings.formatDouble(device.chargingAmpere ?? 0)}A)",
                              style: AppTextStyle.body4),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
