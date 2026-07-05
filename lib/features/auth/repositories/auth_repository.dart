import 'package:flutter/foundation.dart';
import 'package:mini_home/core/constants/api_endpoints.dart';
import 'package:mini_home/core/network/dio_client.dart';
import 'package:mini_home/core/network/models/api_request_base.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository._(dioClient);
}

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository._(this._dioClient);

  Future<Result> signUp({
    required String email,
    required String password,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.signUp,
      method: HttpMethod.post,
      isLoggedInContent: false,
      body: {
        'user': {
          'email': email,
          'password': password,
        }
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );

    return response ?? Failure('Unknown error');
  }

  Future<Result> signIn({
    required String email,
    required String password,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.signIn,
      method: HttpMethod.post,
      isLoggedInContent: false,
      body: {
        'user': {
          'email': email,
          'password': password,
        }
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        debugPrint('SignIn Error: $message, Code: $code');
        response = Failure(
          message,
          code: code,
        );
      },
    );

    debugPrint('SignIn Response: $response');
    return response ?? Failure('Unknown error');
  }

  Future<Result> refreshAccessToken({
    required String refreshToken,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.refreshToken,
      method: HttpMethod.post,
      isLoggedInContent: false,
      body: {
        'refreshToken': refreshToken,
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );

    return response ?? Failure('Unknown error');
  }

  Future<Result> withDrawUser() async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.withdrawUser,
      method: HttpMethod.post,
      isLoggedInContent: true,
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> resendConfirmationEmail() async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.resendConfirmEmail,
      method: HttpMethod.post,
      isLoggedInContent: true,
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> sendPasswordResetMail({
    required String email,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.passwordResetInstructions,
      method: HttpMethod.post,
      isLoggedInContent: false,
      body: {
        'user': {'email': email}
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );

    return response ?? Failure('Unknown error');
  }

  Future<Result> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.changePassword,
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );
    return response ?? Failure('Unknown error');
  }
}
