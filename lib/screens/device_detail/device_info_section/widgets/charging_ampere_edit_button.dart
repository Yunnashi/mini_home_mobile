import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';

class ChargingAmpereEditButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const ChargingAmpereEditButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 16, 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppColors.text, size: 20),
              const SizedBox(width: 4),
              Text(AppStrings.deviceDetailChangeChargingAmpere,
                  style: AppTextStyle.body3),
            ],
          ),
        ),
      ),
    );
  }
}
