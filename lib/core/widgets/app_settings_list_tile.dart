import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/text_style.dart';

class AppSettingsListTile extends StatelessWidget {
  const AppSettingsListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.titleStyle,
    this.showTrailing = true,
  });

  final String title;
  final VoidCallback onTap;
  final String? subtitle;
  final IconData? icon;
  final TextStyle? titleStyle;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: icon == null ? 0 : AppSpacing.sm,
      leading: icon == null
          ? null
          : SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                icon,
                color: AppColors.text,
                size: 24,
              ),
            ),
      title: Text(
        title,
        style: titleStyle ?? AppTextStyle.body1,
      ),
      subtitle: subtitle?.isNotEmpty == true ? Text(subtitle!) : null,
      dense: true,
      trailing: showTrailing
          ? const Icon(
              Icons.navigate_next,
              size: 24,
              color: AppColors.text,
            )
          : null,
      onTap: onTap,
    );
  }
}
