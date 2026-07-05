import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';

class WithdrawalScreen extends ConsumerWidget {
  const WithdrawalScreen({super.key});

  void _onBack(BuildContext context) {
    context.pop();
  }

  void _showSuccessDialog(BuildContext context) {
    BasicDialog.show(
      context: context,
      title: AppStrings.successWithdrawal,
      content: Text(
        AppStrings.contentSuccessWithdrawal,
        textAlign: TextAlign.center,
      ),
      barrierDismissible: false,
      buttons: [
        BasicDialogButton.cancel(
            text: AppStrings.close,
            callback: () {
              context.pop("withdraw complete");
            }),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context, WidgetRef ref) {
    BasicDialog.show(
      context: context,
      title: AppStrings.withdraw,
      content: Text(
        AppStrings.confirmWithdraw,
        textAlign: TextAlign.center,
      ),
      barrierDismissible: false,
      buttons: [
        BasicDialogButton.ok(
          text: AppStrings.withdraw,
          color: AppColors.red,
          autoClose: false,
          callback: () {
            final authService = ref.read(authServiceProvider.notifier);
            authService.withdraw(successCallback: () {
              context.pop();
              _showSuccessDialog(context);
            }, errorCallback: (message, code) {
              BasicDialog.showError(
                  context: context, errorMessage: message, errorCode: code);
            });
          },
        ),
        BasicDialogButton.cancel(),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasicScreen(
        appBar: BasicAppBar.buildPushStyle(
          context: context,
          titleAppBar: AppStrings.withdrawalTitle,
          onBackPressed: () => _onBack(context),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppStrings.contentWithdraw,
                        style: AppTextStyle.body2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      )),
                  const SizedBox(height: 40),
                  BasicButton.buildLarge(
                      text: AppStrings.withdraw,
                      color: AppColors.red,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showConfirmDialog(context, ref);
                      }),
                  const SizedBox(height: 24),
                  BasicButton.buildLarge(
                      text: AppStrings.cancel,
                      buttonType: ButtonType.text,
                      color: AppColors.text,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _onBack(context);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
