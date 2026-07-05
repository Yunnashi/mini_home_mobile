import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/basic_textfield.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/utils/validate_text.dart';
import 'package:mini_home/core/themes/text_style.dart';

class SignInScreen extends HookConsumerWidget {
  SignInScreen({Key? key}) : super(key: key);

  void _navigatorToHome(BuildContext context) {
    context.goNamed(AppRoutes.home);
  }

  void _navigatorToSignUp(BuildContext context) {
    context.goNamed(AppRoutes.signUp);
  }

  void _handleSignIn({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
  }) {
    final authService = ref.read(authServiceProvider.notifier);
    authService.signIn(
        email: email,
        password: password,
        successCallback: () {
          BasicToast.showToast(
              AppStrings.messageDialogLoginSuccess, ToastType.success);
          _navigatorToHome(context);
        },
        errorCallback: (message, code) {
          BasicDialog.showError(
            context: context,
            title: AppStrings.titleDialogLoginError,
            errorMessage: message,
            errorCode: code,
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    bool checkValidity() {
      final isValid = formKey.currentState?.validate() ?? false;
      return isValid;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasicScreen(
        appBar: BasicAppBar.buildPresentStyle(
            context: context,
            titleAppBar: AppStrings.titleSignIn,
            onBackPressed: () => _navigatorToHome(context)),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: AutofillGroup(
                child: Column(
                  children: [
                    BasicTextField(
                      labelText: AppStrings.lblEmail,
                      hint: AppStrings.emailHint,
                      controller: emailController,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username
                      ],
                      validators: [
                        ValidateText.requiredField,
                        ValidateText.email
                      ],
                    ),
                    const SizedBox(height: 24),
                    BasicTextField(
                      isSecurity: true,
                      labelText: AppStrings.lblPassword,
                      hint: "",
                      textInputAction: TextInputAction.done,
                      controller: passwordController,
                      autofillHints: [AutofillHints.password],
                      useSwitchObscureText: true,
                      validators: [
                        ValidateText.requiredField,
                      ],
                    ),
                    const SizedBox(height: 64),
                    BasicButton.buildLarge(
                        text: AppStrings.titleSignIn,
                        shapeType: ShapeType.rounded,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (!checkValidity()) {
                            return;
                          }
                          _handleSignIn(
                            context: context,
                            ref: ref,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }),
                    const SizedBox(height: 24),
                    SizedBox(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              context.pushNamed(AppRoutes.passwordReset);
                            },
                            child: Text(
                              AppStrings.toPasswordReset,
                              style: AppTextStyle.body2TextUnderLine,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _navigatorToSignUp(context);
                            },
                            child: Text(
                              AppStrings.txtToSingUp,
                              style: AppTextStyle.body2TextUnderLine,
                            ),
                          ),
                        ],
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
