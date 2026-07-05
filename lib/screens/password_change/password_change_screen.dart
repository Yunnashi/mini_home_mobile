import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/basic_textfield.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/widgets/password_validator.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/utils/validate_text.dart';

class PasswordChangeScreen extends HookConsumerWidget {
  const PasswordChangeScreen({super.key});

  void _onBack(BuildContext context) {
    context.pop();
  }

  void _navigatorToPasswordReset(BuildContext context) {
    _onBack(context);
    context.pushNamed(AppRoutes.passwordReset);
  }

  void _handleChangePassword({
    required BuildContext context,
    required WidgetRef ref,
    required String currentPassword,
    required String newPassword,
  }) {
    final authService = ref.read(authServiceProvider.notifier);
    authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        successCallback: () {
          BasicToast.showToast(
              AppStrings.messageToastChangePasswordSuccess, ToastType.success);
          _onBack(context);
        },
        errorCallback: (message, code) {
          BasicDialog.showError(
              context: context, errorMessage: message, errorCode: code);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final showPasswordValidator = useState(false);

    bool checkValidity() {
      final isValid = formKey.currentState?.validate() ?? false;
      return isValid;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasicScreen(
        appBar: BasicAppBar.buildPushStyle(
          context: context,
          titleAppBar: AppStrings.passwordChangeTitle,
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
                    const SizedBox(height: 8),
                    BasicTextField(
                      labelText: AppStrings.lblCurrentPassword,
                      isSecurity: true,
                      autofillHints: [AutofillHints.password],
                      controller: currentPasswordController,
                      useSwitchObscureText: true,
                      validators: [
                        ValidateText.requiredField,
                      ],
                    ),
                    const SizedBox(height: 24),
                    BasicTextField(
                      labelText: AppStrings.lblNewPassword,
                      isSecurity: true,
                      hint: AppStrings.passwordPrerequisite,
                      controller: newPasswordController,
                      useSwitchObscureText: true,
                      onChanged: (value) {
                        showPasswordValidator.value = value.isNotEmpty;
                      },
                      validators: [
                        ValidateText.requiredField,
                      ],
                    ),
                    // カスタムウィジェットを使用したバリデーション
                    if (showPasswordValidator.value)
                      CustomPwValidator(
                        controller: newPasswordController,
                      ),
                    const SizedBox(height: 24),
                    BasicTextField(
                      isSecurity: true,
                      labelText: AppStrings.lblConfirmNewPassword,
                      hint: AppStrings.passwordPrerequisite,
                      textInputAction: TextInputAction.done,
                      controller: confirmPasswordController,
                      useSwitchObscureText: true,
                      validators: [
                        ValidateText.requiredField,
                        (value) => ValidateText.matchRelatedField(
                            value,
                            newPasswordController.text,
                            AppStrings.lblNewPassword)
                      ],
                    ),
                    const SizedBox(height: 24),
                    BasicButton.buildLarge(
                        text: AppStrings.txtBtnChange,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (!checkValidity()) {
                            return;
                          }
                          _handleChangePassword(
                            context: context,
                            ref: ref,
                            currentPassword: currentPasswordController.text,
                            newPassword: newPasswordController.text,
                          );
                        }),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () => _navigatorToPasswordReset(context),
                      child: Text(
                        AppStrings.toPasswordReset,
                        style: AppTextStyle.body2TextUnderLine,
                      ),
                    ),
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
