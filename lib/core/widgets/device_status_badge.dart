import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/features/device/models/device_status.dart';

class DeviceStatusBadge extends StatelessWidget {
  final DeviceStatus deviceStatus;
  const DeviceStatusBadge({super.key, required this.deviceStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: deviceStatus.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          deviceStatus.label,
          style: AppTextStyle.body1TextWhite.copyWith(
            color: deviceStatus.color,
          ),
        ),
      ],
    );
  }
}
