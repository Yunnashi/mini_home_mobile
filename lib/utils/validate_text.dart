import 'package:email_validator/email_validator.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/utils/string_utils.dart';

class ValidateText {
  static String? email(String? value) {
    if (value != null) {
      if (!EmailValidator.validate(value)) {
        return AppStrings.emailInputError;
      }
    }
    return null;
  }

  static String? requiredField(String? value) {
    if (value.isNullOrEmpty) {
      return AppStrings.messageRequired;
    }
    return null;
  }

  static String? matchRelatedField(
      String? value, String? relatedValue, String relatedFieldTitle) {
    if (value != relatedValue) {
      return AppStrings.messageIncorrectRelatedValue(relatedFieldTitle);
    }
    return null;
  }
}
