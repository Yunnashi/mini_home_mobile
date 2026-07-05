import 'package:mini_home/core/themes/strings.dart';

/// サーバーから受信したエラーメッセージ以外、アプリが独自に出力したいエラー文言を定義します。
class AppCustomErrors {
  static AppCustomError get duplicateRequestError =>
      AppCustomError(message: "Duplicate request error", code: "S9994");

  static AppCustomError get badResponseError =>
      AppCustomError(message: AppStrings.errorBadResponse, code: "S9995");

  static AppCustomError get authorizationError =>
      AppCustomError(message: AppStrings.errorAuthorization, code: "S9996");

  static AppCustomError get serverError =>
      AppCustomError(message: AppStrings.errorServer, code: "S9997");

  static AppCustomError get unstableNetworkError =>
      AppCustomError(message: AppStrings.errorNetwork, code: "S9998");

  static AppCustomError get unknownError =>
      AppCustomError(message: AppStrings.unknownError, code: "S9999");
}

class AppCustomError {
  final String message;
  final String code;

  const AppCustomError({
    required this.message,
    required this.code,
  });

  Map<String, String> toMap() => {"message": message, "code": code};
}
