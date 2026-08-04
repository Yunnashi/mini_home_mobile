import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/environment/environment.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/web_view/models/web_view_args.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_settings_list_tile.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:mini_home/utils/app_package_info.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/utils/phone_utils.dart';
import 'package:mini_home/utils/string_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingDrawer extends ConsumerWidget {
  const SettingDrawer({
    this.embedded = false,
    Key? key,
  }) : super(key: key);

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfoAsync = ref.watch(packageInfoProvider);
    final authStateAsync = ref.watch(authStateServiceProvider);

    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom + 16
        : 8;

    return packageInfoAsync.when(
      data: (packageInfo) => LayoutBuilder(
        builder: (context, constraints) {
          if (embedded) {
            return Container(
              color: AppColors.white,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  bottomPadding + 24,
                ),
                child: Column(
                  children: [
                    authStateAsync.when(
                      data: (state) => state.isLoggedIn
                          ? _LoggedInContents(
                              state: state,
                              packageInfo: packageInfo,
                            )
                          : _NotLoggedInContents(
                              packageInfo: packageInfo,
                            ),
                      loading: () => const CircularProgressIndicator(
                        color: AppColors.grey,
                      ),
                      error: (e, __) {
                        safeDebugPrint("Error loading auth state: $e");
                        return const Text("");
                      },
                    ),
                    SizedBox(height: 40 + bottomPadding),
                    Text(
                      "Version: ${packageInfo.generateVersionString()}",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final screenHeight = MediaQuery.of(context).size.height;
          final topPadding = MediaQuery.of(context).padding.top;
          final drawerHeight = screenHeight - topPadding - 64;

          return Container(
            height: drawerHeight,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: embedded
                  ? BorderRadius.zero
                  : const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
            ),
            child: Stack(
              children: [
                // コンテンツが多くなった時用にスクロール可に。(+大きい文字対応)
                Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: embedded ? 24 : 80,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!embedded) const SizedBox(height: 40),
                          authStateAsync.when(
                            data: (state) => state.isLoggedIn
                                ? _LoggedInContents(
                                    state: state,
                                    packageInfo: packageInfo,
                                  )
                                : _NotLoggedInContents(
                                    packageInfo: packageInfo,
                                  ),
                            loading: () => const CircularProgressIndicator(
                              color: AppColors.grey,
                            ),
                            error: (e, __) {
                              safeDebugPrint("Error loading auth state: $e");
                              return const Text("");
                            },
                          ),
                          // バージョン情報のスペースを確保
                          SizedBox(height: 40 + bottomPadding),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!embedded)
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.text,
                          size: 24.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                // バージョン情報（下に固定）
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    color: AppColors.white,
                    padding:
                        EdgeInsets.only(bottom: bottomPadding + 10, top: 10),
                    child: Text(
                      "Version: ${packageInfo.generateVersionString()}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      loading: () => const CircularProgressIndicator(
        color: AppColors.lightGrey,
      ),
      error: (e, __) {
        safeDebugPrint("Error loading package info: $e");
        return const Text("");
      },
    );
  }
}

class _NotLoggedInContents extends StatelessWidget {
  const _NotLoggedInContents({
    required this.packageInfo,
    Key? key,
  }) : super(key: key);
  final AppPackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppSettingsListTile(
          title: AppStrings.titleSignUp,
          onTap: () {
            context.pushNamed(AppRoutes.signUp);
          },
        ),
        AppSettingsListTile(
          title: AppStrings.titleSignIn,
          onTap: () {
            context.pushNamed(AppRoutes.signIn);
          },
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: AppColors.border,
        ),
        const SizedBox(height: 8),
        const _LegalContents(),
        AppSettingsListTile(
          title: AppStrings.lblLicensesInfo,
          onTap: () {
            showLicensePage(
                context: context, applicationName: packageInfo.appName());
          },
        ),
        _InquiryContents(),
      ],
    );
  }
}

class _LoggedInContents extends ConsumerWidget {
  const _LoggedInContents({
    required this.state,
    required this.packageInfo,
    Key? key,
  }) : super(key: key);
  final AuthState state;
  final AppPackageInfo packageInfo;

  void _handleSignout(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider.notifier);

    BasicDialog.show(
      context: context,
      title: AppStrings.signout,
      content: Text(AppStrings.confirmSignout),
      barrierDismissible: true,
      buttons: [
        BasicDialogButton.ok(
          callback: () async {
            await authService.signout();
            ref.invalidate(authStateServiceProvider);
            BasicDialog.show(
              context: context,
              title: AppStrings.signoutComplete,
              barrierDismissible: false,
              buttons: [
                BasicDialogButton.ok(),
              ],
            );
          },
        ),
        BasicDialogButton.cancel(),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppSettingsListTile(
          title: AppStrings.accountSettingsTitle,
          subtitle: state.email,
          icon: Icons.person_outline,
          onTap: () async {
            context.pushNamed(AppRoutes.accountSettings);
          },
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: AppColors.border,
        ),
        const SizedBox(height: 8),
        const _LegalContents(),
        AppSettingsListTile(
          title: AppStrings.lblLicensesInfo,
          onTap: () {
            showLicensePage(
                context: context, applicationName: packageInfo.appName());
          },
        ),
        _InquiryContents(),
        const SizedBox(height: 16),
        AppSettingsListTile(
          title: AppStrings.signout,
          titleStyle: AppTextStyle.body1TextRed,
          showTrailing: false,
          onTap: () => _handleSignout(context, ref),
        ),
      ],
    );
  }
}

class _LegalContents extends ConsumerWidget {
  const _LegalContents({Key? key}) : super(key: key);

  void _navigateToTerms(BuildContext context, WidgetRef ref) {
    context.pushNamed(
      AppRoutes.webView,
      extra: WebViewArgs.toTerms(),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context, WidgetRef ref) {
    context.pushNamed(
      AppRoutes.webView,
      extra: WebViewArgs.toPrivacy(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppSettingsListTile(
          title: AppStrings.lblTerms,
          onTap: () => _navigateToTerms(context, ref),
        ),
        AppSettingsListTile(
          title: AppStrings.lblPrivacyPolicy,
          onTap: () => _navigateToPrivacyPolicy(context, ref),
        ),
      ],
    );
  }
}

class _InquiryContents extends ConsumerWidget {
  _InquiryContents();

  void _navigateToFaq(BuildContext context, WidgetRef ref) {
    context.pushNamed(
      AppRoutes.webView,
      extra: WebViewArgs.toFaq(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(appEnvironmentProvider);
    final String? contactTel = env.config.contactTel;
    List<Widget> items = [];

    items.add(
      AppSettingsListTile(
        title: AppStrings.lblFaq,
        onTap: () => _navigateToFaq(context, ref),
      ),
    );

    if (!contactTel.isNullOrEmpty) {
      items.add(
        AppSettingsListTile(
          title: AppStrings.inquiryTitle,
          subtitle: contactTel!,
          onTap: () {
            PhoneUtils.openPhoneCall(contactTel);
          },
        ),
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: items,
    );
  }
}
