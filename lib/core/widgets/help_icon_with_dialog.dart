import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';

class HelpIconWithDialog extends StatelessWidget {
  final double? iconSize;
  final String title;
  final Widget content;

  const HelpIconWithDialog(
      {super.key,
      this.iconSize = 24,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(
        Icons.help_outlined,
        size: iconSize,
        color: AppColors.greyText,
      ),
      onPressed: () {
        BasicDialog.show(
          context: context,
          title: title,
          content: content,
          barrierDismissible: true,
          buttons: [
            BasicDialogButton.cancel(text: AppStrings.close),
          ],
        );
      },
    );
  }
}
