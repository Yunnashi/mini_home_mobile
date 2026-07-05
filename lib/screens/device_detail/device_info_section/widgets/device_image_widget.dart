import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/core/themes/images.dart';

class DeviceImageWidget extends StatelessWidget {
  final Device device;
  final WidgetRef ref;
  const DeviceImageWidget({super.key, required this.device, required this.ref});

  @override
  Widget build(BuildContext context) {
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
                  color: device.status.color.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: -30,
                ),
              ],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              device.model.getImagePath(ref.watch(appImagesProvider)),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
