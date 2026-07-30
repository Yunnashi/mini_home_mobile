import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';

class MiniHomeDeviceCard extends StatelessWidget {
  const MiniHomeDeviceCard({
    required this.name,
    required this.icon,
    required this.roomName,
    required this.status,
    required this.isPowerOn,
    required this.isOnline,
    this.detail,
    this.iconColor = AppColors.primary,
    this.iconBackgroundColor = AppColors.primaryContainer,
    this.infoPills = const [],
    this.onTap,
    this.onPowerChanged,
    super.key,
  });

  final String name;
  final IconData icon;
  final String roomName;
  final String status;
  final String? detail;
  final bool isPowerOn;
  final bool isOnline;
  final Color iconColor;
  final Color iconBackgroundColor;
  final List<MiniHomeDeviceInfoPill> infoPills;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPowerChanged;

  @override
  Widget build(BuildContext context) {
    final active = isOnline && isPowerOn;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(AppRadius.control),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Icon(
                        icon,
                        color: isOnline ? iconColor : AppColors.greyText,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        Text(
                          '$roomName | $status',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.greyText,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    onPressed: isOnline && onPowerChanged != null
                        ? () => onPowerChanged!(!isPowerOn)
                        : null,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          active ? AppColors.primary : AppColors.background,
                      foregroundColor:
                          active ? AppColors.whiteText : AppColors.greyText,
                      disabledBackgroundColor: AppColors.background,
                      disabledForegroundColor: AppColors.placeholder,
                    ),
                    icon: const Icon(Icons.power_settings_new_rounded),
                  ),
                ],
              ),
              if (detail != null) ...[
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    detail!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: active ? AppColors.text : AppColors.greyText,
                        ),
                  ),
                ),
              ],
              if (infoPills.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    for (final entry in infoPills.indexed) ...[
                      if (entry.$1 != 0) const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _MiniHomeDeviceInfoPill(
                          icon: entry.$2.icon,
                          label: entry.$2.label,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MiniHomeDeviceInfoPill {
  const MiniHomeDeviceInfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class _MiniHomeDeviceInfoPill extends StatelessWidget {
  const _MiniHomeDeviceInfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.greyText),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
