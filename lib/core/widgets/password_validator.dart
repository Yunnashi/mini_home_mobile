import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:mini_home/utils/password_validator_service.dart';
import 'package:mini_home/core/themes/colors.dart';

class CustomPwValidator extends HookWidget {
  final TextEditingController controller;
  final GlobalKey? validatorKey;

  const CustomPwValidator({
    required this.controller,
    this.validatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterPwValidator(
      key: validatorKey,
      controller: controller,
      lowercaseCharCount: 1,
      numericCharCount: 1,
      specialCharCount: 1,
      minLength: 8,
      onSuccess: () {
        // パスワードが条件を満たした場合の処理
        safeDebugPrint("Password is valid");
      },
      onFail: () {
        // パスワードが条件を満たさなかった場合の処理
        safeDebugPrint("Password is invalid");
      },
      successColor: AppColors.green,
      failureColor: AppColors.red,
      defaultColor: AppColors.grey,
    );
  }
}

class FlutterPwValidator extends HookWidget {
  final int lowercaseCharCount, numericCharCount, specialCharCount, minLength;
  final Color defaultColor, successColor, failureColor;
  final Function onSuccess;
  final Function? onFail;
  final TextEditingController controller;
  final FlutterPwValidatorStrings? strings;
  final Key? key;

  FlutterPwValidator({
    required this.onSuccess,
    required this.controller,
    required this.minLength,
    this.lowercaseCharCount = 0,
    this.numericCharCount = 0,
    this.specialCharCount = 0,
    this.successColor = AppColors.green,
    this.failureColor = AppColors.red,
    this.defaultColor = AppColors.grey,
    this.strings,
    this.onFail,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    // 初回実行かどうかを判定するフラグ
    final isFirstRun = useState(true);

    final translatedStrings = useMemoized(
      () => strings ?? FlutterPwValidatorStrings.fromContext(context),
      [strings],
    );

    final conditionsHelper = useMemoized(
      () => ConditionsHelper(translatedStrings),
      [translatedStrings],
    );

    final validator = useMemoized(() => Validator(), []);

    // 現在の条件の状態を保持する変数
    final hasMinLowercaseChar = useState<dynamic>(null);
    final hasMinNumericChar = useState<dynamic>(null);
    final hasMinSpecialChar = useState<dynamic>(null);
    final hasMinLength = useState<dynamic>(null);

    // ユーザーがTextFieldに文字を入力するたびに呼び出される
    void validate() {
      // 各条件に対してバリデータを呼び出し、その新しい状態を取得
      hasMinLowercaseChar.value = conditionsHelper.checkCondition(
          lowercaseCharCount,
          validator.hasMinLowercase,
          controller,
          translatedStrings.lowercaseLetters,
          hasMinLowercaseChar.value);

      hasMinNumericChar.value = conditionsHelper.checkCondition(
          numericCharCount,
          validator.hasMinNumericChar,
          controller,
          translatedStrings.numericCharacters,
          hasMinNumericChar.value);

      hasMinSpecialChar.value = conditionsHelper.checkCondition(
          specialCharCount,
          validator.hasMinSpecialChar,
          controller,
          translatedStrings.specialCharacters,
          hasMinSpecialChar.value);

      hasMinLength.value = conditionsHelper.checkCondition(
          minLength,
          validator.hasMinLength,
          controller,
          translatedStrings.atLeast,
          hasMinLength.value);

      // すべての条件がtrueの場合、onSuccessを呼び出し、そうでない場合はonFailメソッドを呼び出す
      int conditionsCount = conditionsHelper.getter()!.length;
      int trueCondition = 0;
      for (bool value in conditionsHelper.getter()!.values) {
        if (value == true) trueCondition += 1;
      }
      if (conditionsCount == trueCondition) {
        onSuccess();
      } else if (onFail != null) {
        onFail!();
      }
    }

    useEffect(() {
      // 各条件に対してユーザーが入力した値を設定
      conditionsHelper.setSelectedCondition(
          lowercaseCharCount, numericCharCount, specialCharCount, minLength);

      // TextFieldの入力が変更された後に実行されるリスナーコールバックを追加
      void listener() {
        isFirstRun.value = false;
        validate();
      }

      controller.addListener(listener);

      return () => controller.removeListener(listener);
    }, [controller]);

    return Column(
      children: [
        const SizedBox(height: 5),
        IntrinsicHeight(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 入力値をチェックし、trueの場合は緑のバリデーションバーを作成
                      for (bool value in conditionsHelper.getter()!.values)
                        if (value == true)
                          ValidationBarComponent(color: successColor),

                      // 入力値をチェックし、falseの場合は赤のバリデーションバーを作成
                      for (bool value in conditionsHelper.getter()!.values)
                        if (value == false)
                          ValidationBarComponent(color: defaultColor)
                    ],
                  ),
                ),
                Flexible(
                  flex: 9,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      // 条件マップのエントリを反復処理し、各項目に対して新しいValidationTextWidgetを生成
                      children: conditionsHelper.getter()!.entries.map((entry) {
                        int? value;
                        if (entry.key == translatedStrings.lowercaseLetters)
                          value = lowercaseCharCount;
                        if (entry.key == translatedStrings.numericCharacters)
                          value = numericCharCount;
                        if (entry.key == translatedStrings.specialCharacters)
                          value = specialCharCount;
                        if (entry.key == translatedStrings.atLeast)
                          value = minLength;
                        return ValidationTextWidget(
                          color: isFirstRun.value
                              ? defaultColor
                              : entry.value
                                  ? successColor
                                  : failureColor,
                          text: entry.key,
                          value: value,
                          isSuccess: isFirstRun.value ? null : entry.value,
                        );
                      }).toList()),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// TextFieldの下に表示されるバリデーションバー
class ValidationBarComponent extends StatelessWidget {
  final Color color;

  ValidationBarComponent({required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.005),
        height: MediaQuery.of(context).size.width * 0.015,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width))),
      ),
    );
  }
}

// バリデーションバーの下に表示されるバリデーションテキスト
class ValidationTextWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int? value;
  final bool? isSuccess;

  ValidationTextWidget({
    required this.color,
    required this.text,
    required this.value,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    if (isSuccess == true) {
      iconData = Icons.check_circle_outline;
    } else if (isSuccess == false) {
      iconData = Icons.highlight_off;
    } else {
      iconData = Icons.panorama_fish_eye;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.04,
          height: MediaQuery.of(context).size.width * 0.04,
          child: Icon(
            iconData,
            color: color,
            size: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Expanded(
          child: Text(
            text.replaceFirst("-", value.toString()),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: color,
            ),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
