import 'package:flutter/cupertino.dart';

// バリデーションテキスト
import 'package:easy_localization/easy_localization.dart';

class FlutterPwValidatorStrings {
  final String lowercaseLetters;
  final String numericCharacters;
  final String specialCharacters;
  final String atLeast;

  FlutterPwValidatorStrings({
    required this.lowercaseLetters,
    required this.numericCharacters,
    required this.specialCharacters,
    required this.atLeast,
  });

  factory FlutterPwValidatorStrings.fromContext(BuildContext context) {
    return FlutterPwValidatorStrings(
      lowercaseLetters:
          tr('commons.validations.password.lowercase'), // 例: 半角英字-字以上
      numericCharacters:
          tr('commons.validations.password.number'), // 例: 半角数字-字以上
      specialCharacters:
          tr('commons.validations.password.symbol'), // 例: 特殊文字-字以上
      atLeast: tr('commons.validations.password.min_length'), // 例: - 文字以上
    );
  }
}

// Validatorクラスは、指定されたバリデーションのための正規表現を保持します
class Validator {
  // パスワードが指定された数の小文字を含んでいるかをチェックします
  bool hasMinLowercase(String password, int lowercaseCount) {
    String pattern = '^(.*?[a-z]){' + lowercaseCount.toString() + ',}';
    return password.contains(RegExp(pattern));
  }

  // パスワードが指定された数の数字を含んでいるかをチェックします
  bool hasMinNumericChar(String password, int numericCount) {
    String pattern = '^(.*?[0-9]){' + numericCount.toString() + ',}';
    return password.contains(RegExp(pattern));
  }

  // パスワードが指定された数の特殊文字を含んでいるかをチェックします
  bool hasMinSpecialChar(String password, int specialCount) {
    String pattern =
        r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){" + specialCount.toString() + ",}";
    return password.contains(RegExp(pattern));
  }

  // パスワードが指定された最小長を満たしているかをチェックします
  bool hasMinLength(String password, int minLength) {
    return password.length >= minLength;
  }
}

// このクラスは、ユーザーが選択した条件を認識し、それらをチェックするためのヘルパークラスです
class ConditionsHelper {
  ConditionsHelper(this.strings);

  final FlutterPwValidatorStrings strings;
  Map<String, bool>? _selectedCondition;

  // ウィジェットのコンストラクタからユーザーが選択した条件を取得し、それらをマップに設定します
  void setSelectedCondition(
      int lowercaseCharCount, numericCharCount, specialCharCount, minLength) {
    _selectedCondition = {
      if (lowercaseCharCount > 0) strings.lowercaseLetters: false,
      if (numericCharCount > 0) strings.numericCharacters: false,
      if (specialCharCount > 0) strings.specialCharacters: false,
      if (minLength > 0) strings.atLeast: false
    };
  }

  // 条件の新しい値をチェックし、バリデータを通してその結果をマップに設定して新しい値を返します
  dynamic checkCondition(int userRequestedValue, Function validator,
      TextEditingController controller, String key, dynamic oldValue) {
    dynamic newValue;

    // 指定した値が0より大きい場合、その条件を選択したことを意味し、新しい値をチェックする必要があります
    if (userRequestedValue > 0) {
      newValue = validator(controller.text, userRequestedValue);
    } else {
      newValue = null;
    }

    if (newValue == null) {
      return null;
    } else if (newValue != oldValue) {
      _selectedCondition![key] = newValue;
      return newValue;
    } else {
      return oldValue;
    }
  }

  // 条件とその満たされているかどうかの状態を保持するマップを返します
  Map<String, bool>? getter() => _selectedCondition;
}
