import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/device_status_badge.dart';
import 'package:mini_home/core/widgets/help_icon_with_dialog.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/features/device/models/device_status.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback? onTap;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.51),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FixedColumnWidth(32),
                  2: FlexColumnWidth()
                },
                children: [
                  TableRow(
                    children: [
                      Row(
                        children: [
                          Text(AppStrings.deviceStatus,
                              style: AppTextStyle.body3TextGrey),
                          const SizedBox(width: 6),
                          HelpIconWithDialog(
                            iconSize: 20,
                            title: AppStrings.deviceStatusHelpTitle,
                            content: const DeviceStatusHelpContent(),
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),
                      DeviceStatusBadge(
                        deviceStatus: device.status,
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(AppStrings.deviceTemperature,
                          style: AppTextStyle.body3TextGrey),
                      const SizedBox(width: 32),
                      Text(
                        AppStrings.temperatureToText(device.temperature != null
                            ? device.temperature!
                            : 0),
                        style: AppTextStyle.body1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  const TableRow(
                    children: [
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(AppStrings.deviceId,
                          style: AppTextStyle.body3TextGrey),
                      const SizedBox(width: 32),
                      Text(
                        device.externalDeviceId,
                        style: AppTextStyle.body1,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceStatusHelpContent extends StatelessWidget {
  const DeviceStatusHelpContent({super.key});

  @override
  Widget build(BuildContext context) {
    final descriptions = <DeviceStatus, String>{
      DeviceStatus.disconnected: AppStrings.deviceStatusHelpContentDisconnected,
      DeviceStatus.connected: AppStrings.deviceStatusHelpContentConnected,
      DeviceStatus.chargingStopped:
          AppStrings.deviceStatusHelpContentChargingStopped,
      DeviceStatus.charging: AppStrings.deviceStatusHelpContentCharging,
      DeviceStatus.error: AppStrings.deviceStatusHelpContentError,
      DeviceStatus.otaInProgress:
          AppStrings.deviceStatusHelpContentOtaInProgress,
      DeviceStatus.offline: AppStrings.deviceStatusHelpContentOffline,
    };
    final items = DeviceStatus.values.where((e) => descriptions.containsKey(e));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((status) {
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeviceStatusBadge(deviceStatus: status),
              Text(
                descriptions[status] ?? '',
                style: AppTextStyle.body1TextGrey,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
