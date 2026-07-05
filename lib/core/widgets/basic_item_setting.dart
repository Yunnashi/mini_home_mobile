import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';

class BasicItemSetting extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String title;
  final String? detailTxt;
  final Function() onTap;
  final bool isEndOfItem;

  const BasicItemSetting({
    super.key,
    required this.title,
    required this.onTap,
    this.image,
    this.icon,
    this.detailTxt,
    this.isEndOfItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
          bottom: isEndOfItem
              ? BorderSide(color: AppColors.border, width: 1)
              : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: detailTxt != null
                  ? 1
                  : 2, // detailTxtがある場合は小さいflex値、ない場合は大きいflex値
              child: Text(
                title,
                style: AppTextStyle.body2,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: detailTxt != null
                  ? 2
                  : 1, // detailTxtがある場合は大きいflex値、ない場合は小さいflex値
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (detailTxt != null) ...[
                    Flexible(
                      child: Text(
                        detailTxt!,
                        style: AppTextStyle.body2TextGrey,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  if (icon != null)
                    Icon(
                      icon!,
                      size: 24,
                      color: AppColors.grey,
                    )
                  else if (image != null)
                    Image.asset(
                      image!,
                      width: 16,
                      height: 16,
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
