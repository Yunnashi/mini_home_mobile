class ApiEndpoints {
  ApiEndpoints._();

  // ========== 認証関連エンドポイント ==========
  static const String signIn = '/v1/auth/sign-in';
  static const String signUp = '/v1/auth/sign-up';
  static const String withdrawUser = '/v1/account';
  static const String refreshToken = '/v1/auth/refresh';
  static const String resendConfirmEmail = '/v1/auth/verification/resend';
  static const String passwordResetInstructions = '/v1/auth/password/reset';
  static const String changePassword = '/v1/auth/password';

  static const String homes = '/v1/homes';

  static String home(int homeId) => '$homes/$homeId';
  static String devices(int homeId) => '${home(homeId)}/devices';
  static String device(int homeId, int deviceId) =>
      '${devices(homeId)}/$deviceId';
  static String schedules(int homeId, int deviceId) =>
      '${device(homeId, deviceId)}/schedules';

  // その他のエンドポイントはここに追加
}
