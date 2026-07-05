import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneUtils {
  static String _extractDigits(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'\D'), '');
  }

  static Future<void> openPhoneCall(String phoneNumber) async {
    String cleanedPhoneNumber = _extractDigits(phoneNumber);

    final Uri callLaunchUri = Uri(
      scheme: 'tel',
      path: cleanedPhoneNumber,
    );

    if (await canLaunchUrl(callLaunchUri)) {
      final bool launched = await launchUrl(callLaunchUri);
      if (!launched) {
        BasicToast.showToast(AppStrings.callFailureMessage, ToastType.error);
      }
    } else {
      BasicToast.showToast(AppStrings.callFailureMessage, ToastType.error);
    }
  }
}
