import 'package:flutter/cupertino.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/auth/models/sign_in_response.dart';
import 'package:mini_home/features/auth/repositories/auth_repository.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/device/repositories/fw_update_requested_at_storage_repository.dart';
import 'package:mini_home/utils/loading.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mini_home/features/auth/repositories/auth_storage_repository.dart';
import 'package:mini_home/features/user/services/user_service.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  late final AuthStorageRepository _authStorageRepository;

  @override
  void build() {
    _authStorageRepository = AuthStorageRepository();
  }

  /// ログイン状態を確認する
  Future<bool> isLoggedIn() async {
    final token = await getCurrentAccessToken();
    final user = await ref.read(userServiceProvider.notifier).getCurrentUser();

    return token != null && token.isNotEmpty && user != null;
  }

  /// 登録処理
  Future<void> signUp({
    required String email,
    required String password,
    VoidCallback? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.signUp(
        email: email,
        password: password,
      );

      switch (response) {
        case Success():
          successCallback?.call();
          Loading().dismiss();

        case Failure(message: final message, code: final code):
          Loading().dismiss();
          errorCallback?.call(message, code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'SIGNUP_ERROR');
    }
  }

  /// ログイン処理
  Future<void> signIn({
    required String email,
    required String password,
    VoidCallback? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.signIn(
        email: email,
        password: password,
      );

      switch (response) {
        case Success(value: final data):
          final signInResponse =
              SignInResponse.fromJson(data as Map<String, dynamic>);
          await setCurrentTokens(
            signInResponse.token.accessToken,
            signInResponse.token.refreshToken,
          );
          await ref
              .read(userServiceProvider.notifier)
              .setCurrentUser(signInResponse.user);
          // 認証状態を更新
          ref.invalidate(authStateServiceProvider);
          successCallback?.call();
          Loading().dismiss();

        case Failure(message: final message, code: final code):
          Loading().dismiss();
          errorCallback?.call(message, code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'SIGNIN_ERROR');
    }
  }

  /// アクセストークンを取得する
  Future<String?> getCurrentAccessToken() async {
    return await _authStorageRepository.getCurrentAccessToken();
  }

  /// リフレッシュトークンを取得する
  Future<String?> getCurrentRefreshToken() async {
    return await _authStorageRepository.getCurrentRefreshToken();
  }

  /// トークンを保存する
  Future<void> setCurrentTokens(String accessToken, String refreshToken) async {
    await _authStorageRepository.setCurrentTokens(accessToken, refreshToken);
  }

  /// ログアウト処理
  Future<void> signout() async {
    await _authStorageRepository.clearCurrentTokens();
    await ref.read(userServiceProvider.notifier).clearCurrentUser();
    // FW更新リクエスト日時を削除
    await FwUpdateRequestedAtStorage.clearAll();
    // 認証状態を更新
    ref.invalidate(authStateServiceProvider);
  }

  /// アクセストークンを更新する
  Future<String?> refreshAccessToken() async {
    final refreshToken = await getCurrentRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await signout();
      return null;
    } else {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.refreshAccessToken(
        refreshToken: refreshToken,
      );
      switch (response) {
        case Success(value: final data):
          final signInResponse =
              SignInResponse.fromJson(data as Map<String, dynamic>);
          await setCurrentTokens(
            signInResponse.token.accessToken,
            signInResponse.token.refreshToken,
          );
          return signInResponse.token.accessToken;

        case Failure(message: final message, code: final code):
          safeDebugPrint(
              'Error refreshing access token: $message (Code: $code)');
          return null;
      }
    }
  }

  /// 退会処理
  Future<void> withdraw({
    required VoidCallback successCallback,
    required Function(String?, String?) errorCallback,
  }) async {
    try {
      Loading().show();
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.withDrawUser();
      switch (response) {
        case Success():
          await signout();
          successCallback.call();
          Loading().dismiss();
        case Failure(message: final message, code: final code):
          Loading().dismiss();
          errorCallback.call(message, code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback.call(e.toString(), 'WITHDRAW_ERROR');
    }
  }

  Future<void> resendConfirmationEmail({
    required VoidCallback successCallback,
    required void Function(String?, String?) errorCallback,
  }) async {
    Loading().show();
    final authRepository = ref.read(authRepositoryProvider);
    final response = await authRepository.resendConfirmationEmail();
    switch (response) {
      case Success():
        Loading().dismiss();
        successCallback.call();
      case Failure(message: final message, code: final code):
        Loading().dismiss();
        errorCallback.call(message, code);
    }
  }

  Future<void> sendPasswordResetMail({
    required String email,
    required VoidCallback successCallback,
    required Function(String?, String?) errorCallback,
  }) async {
    Loading().show();
    final authRepository = ref.read(authRepositoryProvider);
    final response = await authRepository.sendPasswordResetMail(email: email);
    switch (response) {
      case Success():
        Loading().dismiss();
        successCallback.call();
        break;
      case Failure(message: final message, code: final code):
        Loading().dismiss();
        errorCallback.call(message, code);
        break;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required VoidCallback successCallback,
    required void Function(String?, String?) errorCallback,
  }) async {
    Loading().show();
    final authRepository = ref.read(authRepositoryProvider);
    final response = await authRepository.changePassword(
        currentPassword: currentPassword, newPassword: newPassword);
    switch (response) {
      case Success():
        Loading().dismiss();
        successCallback.call();
      case Failure(message: final message, code: final code):
        Loading().dismiss();
        errorCallback.call(message, code);
    }
  }
}
