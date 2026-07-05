import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';

class MiniHomeDeviceCard extends StatelessWidget {
  const MiniHomeDeviceCard({
    required this.name,
    required this.icon,
    required this.status,
    required this.isPowerOn,
    required this.isOnline,
    this.detail,
    this.onTap,
    this.onPowerChanged,
    super.key,
  });

  final String name;
  final IconData icon;
  final String status;
  final String? detail;
  final bool isPowerOn;
  final bool isOnline;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPowerChanged;

  @override
  Widget build(BuildContext context) {
    final active = isOnline && isPowerOn;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primaryContainer
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.control),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Icon(
                        icon,
                        color: active ? AppColors.primary : AppColors.greyText,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: isPowerOn,
                    onChanged: isOnline ? onPowerChanged : null,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isOnline ? AppColors.text : AppColors.greyText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                detail == null ? status : '$status · $detail',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.greyText,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
