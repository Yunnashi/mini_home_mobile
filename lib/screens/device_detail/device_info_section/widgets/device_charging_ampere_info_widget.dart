import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/pending_changes_badge.dart';
import 'package:mini_home/screens/device_detail/device_info_section/widgets/charging_ampere_edit_button.dart';
import 'package:mini_home/features/device/models/device.dart';

class DeviceChargingAmpereInfoWidget extends StatelessWidget {
  final Device device;
  final double? pendingChargingAmpere;
  final Future<void> Function(BuildContext context) onSaveChargingAmpereChange;

  const DeviceChargingAmpereInfoWidget({
    super.key,
    required this.device,
    required this.pendingChargingAmpere,
    required this.onSaveChargingAmpereChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChargingAmpereEditButton(
          onPressed: () => onSaveChargingAmpereChange(context),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            if (pendingChargingAmpere != null) PendingChangesBadge(),
            Icon(Icons.bolt, color: device.status.color, size: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  AppStrings.formatDouble(device.chargingKw ?? 0),
                  style: AppTextStyle.body1.copyWith(
                    color: device.status.color,
                    fontSize: 24,
                  ),
                ),
                Text(
                  " kW (${AppStrings.formatDouble(device.chargingAmpere ?? 0)}A)",
                  style: AppTextStyle.body1.copyWith(
                    color: device.status.color,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
