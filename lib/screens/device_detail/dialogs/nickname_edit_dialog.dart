import 'package:flutter/material.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_textfield.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/utils/validate_text.dart';

class NicknameEditDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nicknameController;

  const NicknameEditDialog({
    super.key,
    required this.formKey,
    required this.nicknameController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: BasicTextField(
              labelText: AppStrings.deviceNickname,
              hint: AppStrings.deviceNicknamePlaceholder,
              controller: nicknameController,
              validators: [
                ValidateText.requiredField,
                (value) {
                  if (value != null && value.length > 24) {
                    return AppStrings.messageMaxLengthError(
                        AppStrings.deviceNickname, 24);
                  }
                  return null;
                },
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> showNicknameEditDialog({
  required BuildContext context,
  required String nickname,
  required Future<void> Function(String) onSave,
}) {
  final formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController(text: nickname);
  return BasicDialog.show(
    context: context,
    title: AppStrings.deviceNicknameTitle,
    content: NicknameEditDialog(
      formKey: formKey,
      nicknameController: nicknameController,
    ),
    barrierDismissible: false,
    buttons: [
      BasicDialogButton.ok(
        text: AppStrings.txtBtnChange,
        autoClose: false,
        callback: () {
          if (formKey.currentState?.validate() ?? false) {
            onSave(nicknameController.text);
          }
        },
      ),
      BasicDialogButton.cancel(),
    ],
  );
}
