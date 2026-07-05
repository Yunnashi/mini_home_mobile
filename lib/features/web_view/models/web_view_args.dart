import 'package:easy_localization/easy_localization.dart';
import 'package:mini_home/core/themes/strings.dart';

class WebViewArgs {
  final String title;
  final String content;

  const WebViewArgs({required this.title, required this.content});

  factory WebViewArgs.toTerms() {
    return WebViewArgs(
      title: AppStrings.lblTerms,
      content: 'legal.terms.body'.tr(),
    );
  }

  factory WebViewArgs.toPrivacy() {
    return WebViewArgs(
      title: AppStrings.lblPrivacyPolicy,
      content: 'legal.privacy.body'.tr(),
    );
  }

  factory WebViewArgs.toFaq() {
    return WebViewArgs(
      title: AppStrings.lblFaq,
      content: 'legal.faq.body'.tr(),
    );
  }
}
