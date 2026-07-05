import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';

class ClickableTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final double? trailingIconSize;

  const ClickableTitleRow({
    Key? key,
    required this.title,
    this.onTap,
    this.titleStyle,
    this.trailingIcon = Icons.chevron_right,
    this.trailingIconColor = AppColors.grey,
    this.trailingIconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ?? AppTextStyle.body1,
          ),
          if (trailingIcon != null)
            Icon(
              trailingIcon,
              color: trailingIconColor,
              size: trailingIconSize,
            ),
        ],
      ),
    );
  }
}
