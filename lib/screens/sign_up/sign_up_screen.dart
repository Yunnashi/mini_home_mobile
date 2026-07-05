import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/basic_textfield.dart';
import 'package:mini_home/utils/validate_text.dart';
import 'package:mini_home/features/web_view/models/web_view_args.dart';
import 'package:mini_home/core/widgets/password_validator.dart';

class SignUpScreen extends HookConsumerWidget {
  SignUpScreen({Key? key}) : super(key: key);

  void _navigatorToHome(BuildContext context) {
    context.goNamed(AppRoutes.home);
  }

  void _navigatorToSignIn(BuildContext context) {
    context.goNamed(AppRoutes.signIn);
  }

  void _handleSignUp(
      BuildContext context, WidgetRef ref, String email, String password) {
    final authService = ref.read(authServiceProvider.notifier);
    authService.signUp(
        email: email,
        password: password,
        successCallback: () {
          BasicDialog.show(
            context: context,
            title: AppStrings.titleDialogRegisterSuccess,
            content: Text(AppStrings.msgDialogRegisterSuccess),
            barrierDismissible: false,
            buttons: [
              BasicDialogButton.ok(
                callback: () {
                  _navigatorToSignIn(context);
                },
              ),
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
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final showPasswordValidator = useState(false);

    bool checkValidity() {
      final isValid = formKey.currentState?.validate() ?? false;
      return isValid;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasicScreen(
        appBar: BasicAppBar.buildPresentStyle(
            context: context,
            titleAppBar: AppStrings.titleSignUp,
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
                    const SizedBox(height: 8),
                    BasicTextField(
                      labelText: AppStrings.lblEmail,
                      hint: AppStrings.emailHint,
                      controller: emailController,
                      autofillHints: [
                        AutofillHints.email,
                      ],
                      validators: [
                        ValidateText.requiredField,
                        ValidateText.email
                      ],
                    ),
                    const SizedBox(height: 24),
                    BasicTextField(
                      labelText: AppStrings.lblPassword,
                      isSecurity: true,
                      hint: AppStrings.passwordPrerequisite,
                      controller: passwordController,
                      autofillHints: [AutofillHints.password],
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
                        controller: passwordController,
                      ),
                    const SizedBox(height: 24),
                    BasicTextField(
                      isSecurity: true,
                      labelText: AppStrings.lblPasswordConfirm,
                      hint: AppStrings.passwordPrerequisite,
                      textInputAction: TextInputAction.done,
                      controller: confirmPasswordController,
                      useSwitchObscureText: true,
                      validators: [
                        ValidateText.requiredField,
                        (value) => ValidateText.matchRelatedField(value,
                            passwordController.text, AppStrings.lblPassword)
                      ],
                    ),
                    const SizedBox(height: 64),
                    SizedBox(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.left,
                        softWrap: true,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: AppStrings.lblTerms,
                            style: AppTextStyle.body3TextLink,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                context.pushNamed(
                                  AppRoutes.webView,
                                  extra: WebViewArgs.toTerms(),
                                );
                              },
                          ),
                          TextSpan(
                              text: AppStrings.lblPrivacy2,
                              style: AppTextStyle.body3),
                          TextSpan(
                            text: AppStrings.lblPrivacyPolicy,
                            style: AppTextStyle.body3TextLink,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                context.pushNamed(
                                  AppRoutes.webView,
                                  extra: WebViewArgs.toPrivacy(),
                                );
                              },
                          ),
                          TextSpan(
                              text: AppStrings.lblPrivacy4,
                              style: AppTextStyle.body3),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BasicButton.buildLarge(
                        text: AppStrings.txtBtnSingUp,
                        shapeType: ShapeType.rounded,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (!checkValidity()) {
                            return;
                          }
                          _handleSignUp(context, ref, emailController.text,
                              passwordController.text);
                        }),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () => _navigatorToSignIn(context),
                      child: Text(
                        AppStrings.txtToSingIn,
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
