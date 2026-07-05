import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/basic_textfield.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/utils/validate_text.dart';
import 'package:mini_home/core/themes/text_style.dart';

class PasswordResetScreen extends HookConsumerWidget {
  PasswordResetScreen({Key? key}) : super(key: key);

  void _onBack(BuildContext context) {
    context.pop();
  }

  void _handleSendPasswordResetMail({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
  }) {
    final authService = ref.read(authServiceProvider.notifier);
    authService.sendPasswordResetMail(
        email: email,
        successCallback: () {
          BasicDialog.show(
            context: context,
            title: AppStrings.titleDialogPasswordResetSuccess,
            content: Text(AppStrings.messageDialogPasswordResetSuccess),
            barrierDismissible: false,
            buttons: [
              BasicDialogButton.ok(callback: () {
                _onBack(context);
              }),
            ],
          );
        },
        errorCallback: (message, code) {
          BasicDialog.showError(
              context: context, errorMessage: message, errorCode: code);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();

    bool checkValidity() {
      final isValid = formKey.currentState?.validate() ?? false;
      return isValid;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasicScreen(
        appBar: BasicAppBar.buildPresentStyle(
          context: context,
          titleAppBar: AppStrings.passwordResetTitle,
          onBackPressed: () => _onBack(context),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: AutofillGroup(
                child: Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: Text(
                          AppStrings.passwordResetDescription,
                          style: AppTextStyle.body2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        )),
                    const SizedBox(height: 24),
                    BasicTextField(
                      labelText: AppStrings.lblEmail,
                      hint: AppStrings.emailHint,
                      controller: emailController,
                      autofillHints: [
                        AutofillHints.email,
                        AutofillHints.username
                      ],
                      validators: [
                        ValidateText.requiredField,
                        ValidateText.email
                      ],
                    ),
                    const SizedBox(height: 24),
                    BasicButton.buildLarge(
                        text: AppStrings.passwordResetSendButton,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (!checkValidity()) {
                            return;
                          }
                          _handleSendPasswordResetMail(
                            context: context,
                            ref: ref,
                            email: emailController.text.trim(),
                          );
                        }),
                    const SizedBox(height: 24),
                    SizedBox(
                        width: double.infinity,
                        child: Text(
                          AppStrings.passwordResetDescription2,
                          style: AppTextStyle.body2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
