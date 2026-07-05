class ApiEndpoints {
  ApiEndpoints._();

  // ========== 認証関連エンドポイント ==========
  static const String signIn = '/v1/users/sign-in';
  static const String signUp = '/v1/users/registration';
  static const String withdrawUser = '/v1/users/withdraw';
  static const String refreshToken = '/v1/users/refresh-token';
  static const String resendConfirmEmail = '/v1/users/confirmation/resend';
  static const String passwordResetInstructions =
      '/v1/users/password/reset-instructions';
  static const String changePassword = '/v1/users/password';

  // ========= ユーザーグループ関連エンドポイント ==========
  static const String userGroups = '/v1/users/user-groups';
  static const String homes = '/v1/homes';

  // その他のエンドポイントはここに追加
}
