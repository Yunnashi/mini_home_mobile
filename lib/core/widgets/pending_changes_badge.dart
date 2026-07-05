import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/colors.dart';

class PendingChangesBadge extends HookWidget {
  const PendingChangesBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat();

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          RotationTransition(
            turns: controller,
            child: Icon(Icons.autorenew, size: 12, color: AppColors.orange),
          ),
          const SizedBox(width: 2),
          Text(
            AppStrings.deviceDetailPendingChanges,
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
