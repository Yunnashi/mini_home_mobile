import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/features/device/models/device_type.dart';

class DeviceImageWidget extends StatelessWidget {
  final DeviceType deviceType;
  final Color statusColor;

  const DeviceImageWidget({
    super.key,
    required this.deviceType,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final isAirConditioner = deviceType == DeviceType.airConditioner;
    final icon =
        isAirConditioner ? Icons.air_rounded : Icons.lightbulb_outline_rounded;
    final color =
        isAirConditioner ? AppColors.airConditioner : AppColors.primary;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 208,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(120),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: -30,
                ),
              ],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 180,
            height: 180,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 92,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
