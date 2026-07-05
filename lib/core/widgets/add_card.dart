import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';

/// 中央にプラスアイコンを表示するグレーのカード型のウィジェット
class AddCard extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool hasBoxShadow;

  const AddCard({
    super.key,
    this.onTap,
    this.width,
    this.height,
    this.iconSize = 32,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 5.51,
    this.hasBoxShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: hasBoxShadow
              ? [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: AppColors.grey,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
