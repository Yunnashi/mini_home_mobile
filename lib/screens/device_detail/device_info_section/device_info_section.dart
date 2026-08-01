import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/skeleton.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/screens/device_detail/device_info_section/widgets/device_image_widget.dart';
import 'package:mini_home/screens/device_detail/device_info_section/widgets/device_card.dart';

class DeviceInfoSection extends StatelessWidget {
  final BuildContext context;
  final WidgetRef ref;
  final int? userGroupId;
  final ValueNotifier<Device?> device;
  final bool isLoading;

  const DeviceInfoSection({
    super.key,
    required this.context,
    required this.ref,
    required this.userGroupId,
    required this.device,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // デバイス画像
        if (isLoading)
          const SizedBox(height: 232)
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SizedBox(
              height: 220,
              child: DeviceImageWidget(
                deviceType: device.value!.type,
                statusColor: device.value!.status.color,
              ),
            ),
          ),
        // デバイスの情報カード
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.deviceInfo, style: AppTextStyle.body1),
            const SizedBox(height: 8),
            if (isLoading)
              const Skeleton(height: 110)
            else
              DeviceCard(device: device.value!),
            const SizedBox(height: 16),
          ],
        )
      ],
    );
  }
}
