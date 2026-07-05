import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mini_home/core/constants/api_errors.dart';
import 'package:mini_home/core/constants/custom_errors.dart';
import 'package:mini_home/core/network/duplicate_request_interceptor.dart';
import 'package:mini_home/core/network/log_response_api.dart';
import 'package:mini_home/core/network/models/api_request_base.dart';
import 'package:mini_home/environment/environment.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(Ref ref) {
  final env = ref.watch(appEnvironmentProvider);
  final deviceLanguageCode = PlatformDispatcher.instance.locale.languageCode;
  Map<String, String> headers = <String, String>{
    "Content-type": "application/json; charset=utf-8",
    "Accept": "application/json",
    "x-locale": deviceLanguageCode,
  };
  if (env.config.appApiKey.isNotEmpty) {
    headers["x-api-key"] = env.config.appApiKey;
  }

  final dio = Dio(BaseOptions(
    baseUrl: "${env.config.apiScheme}://${env.config.apiHost}",
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 40),
    sendTimeout: const Duration(seconds: 20),
    headers: headers,
    // 接続を再利用せず、毎回新規接続を試みる
    persistentConnection: false,
  ));

  // リクエストの重複防止インターセプター
  dio.interceptors.add(DuplicateRequestInterceptor());

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isLoggedInContent =
            options.extra['isLoggedInContent'] as bool? ?? false;
        if (isLoggedInContent) {
          final authService = ref.read(authServiceProvider.notifier);
          if (!await authService.isLoggedIn()) {
            _handleInvalidTokenError(authService, handler, options);
            return;
          }
          final accessToken = await authService.getCurrentAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }
        handler.next(options);
      },
      onError: (DioException error, handler) async {
        final isLoggedInContent =
            error.requestOptions.extra['isLoggedInContent'] as bool? ?? false;
        final responseData = error.response?.data;
        final responseCode = responseData is Map<String, dynamic>
            ? responseData['errorCode'] as String?
            : null;

        // 認可エラー発生時はアクセストークンを更新してリトライする
        if (error.response?.statusCode == 401 &&
            isLoggedInContent &&
            responseCode == ApiErrors.invalid_token.errorCode) {
          final authService = ref.read(authServiceProvider.notifier);
          try {
            final newAccessToken = await authService.refreshAccessToken();
            if (newAccessToken != null) {
              // 新しいトークンでリクエストをリトライ
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              final response = await dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } else {
              _handleInvalidTokenError(
                  authService, handler, error.requestOptions);
              return;
            }
          } catch (refreshError) {
            _handleInvalidTokenError(
                authService, handler, error.requestOptions);
            return;
          }
        }

        handler.next(error);
      },
    ),
  );

  return dio;
}

/// 無効なトークンエラーを処理する共通関数
void _handleInvalidTokenError(
  dynamic authService,
  dynamic handler,
  RequestOptions requestOptions,
) {
  authService.signout();
  handler.reject(DioException(
    requestOptions: requestOptions,
    error: ApiErrors.invalid_token.errorCode,
    message: 'User is not logged in',
  ));
}

@riverpod
DioClient dioClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio);
}

class DioClient {
  final Dio _dio;
  DioClient(this._dio);

  // Add a getter to access the current baseUrl
  String get baseUrl => _dio.options.baseUrl;

  Future<void> sendRequest({
    required String resourcePath,
    bool isLoggedInContent = true,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    required HttpMethod method,
    required ValueSetter<dynamic> successCallback,
    required Function(String? message, String? code) errorCallback,
  }) async {
    Response response;
    try {
      final options = Options(
        method: method.name.toUpperCase(),
        extra: {
          'isLoggedInContent': isLoggedInContent,
        },
      );

      final isGet = (method == HttpMethod.get);
      // GETでbodyが指定された場合の警告
      if (isGet && body != null) {
        debugPrint(
            "Warning: Body parameter is ignored for ${method.name.toUpperCase()} requests.");
      }

      // Content-Type: application/jsonを指定する場合はbodyがないとエラーになる為空bodyを送る
      body ??= {};

      response = await _dio.request(
        resourcePath,
        queryParameters: queryParameters,
        data: isGet ? null : body,
        options: options,
      );

      // レスポンスログを出力
      response.printResponse();

      successCallback(response.data);
    } on DioException catch (e) {
      // 重複リクエストによるキャンセルは無視
      if (e.type == DioExceptionType.cancel &&
          e.error == AppCustomErrors.duplicateRequestError.code) {
        safeDebugPrint(
            "[INFO] ${AppCustomErrors.duplicateRequestError.message}: $resourcePath");
        return;
      }

      var error = AppCustomErrors.unknownError;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          error = AppCustomErrors.serverError;
          break;
        case DioExceptionType.connectionError:
          error = AppCustomErrors.unstableNetworkError;
          break;
        case DioExceptionType.badResponse:
          if (e.response?.data != null &&
              e.response!.data is Map<String, dynamic>) {
            _handleErrorResponse(
              response: e.response!.data,
              errorCallback: errorCallback,
            );
            return;
          }
          // pathが見つからない場合のエラー
          error = AppCustomErrors.badResponseError;
          break;
        default:
          // JSONフォーマットエラーの場合
          if (e.error is FormatException) {
            final formatError = e.error as FormatException;
            safeDebugPrint(
                "[ERROR] JSON Format Error at ${method.name.toUpperCase()}:$resourcePath - offset ${formatError.offset}: ${formatError.message}");
          } else if (e.error == ApiErrors.invalid_token.errorCode) {
            error = AppCustomErrors.authorizationError;
          }
          break;
      }
      safeDebugPrint(
          "[ERROR] ${e.type} MESSAGE:${e.message}-${e.error} CODE:${e.response?.statusCode} DATA:${e.response?.data}");
      errorCallback.call(error.message, error.code);
    } catch (e) {
      safeDebugPrint("[ERROR] Unexpected request error: $e");
      final error = AppCustomErrors.unknownError;
      errorCallback.call(error.message, error.code);
    }
  }

  /// エラーレスポンスからメッセージとコードを取り出し、呼び出し元にコールバックするするメソッド
  void _handleErrorResponse({
    required dynamic response,
    required void Function(String? message, String? code) errorCallback,
  }) {
    final message = response["message"] as String?;
    final code = response["errorCode"] as String?;
    errorCallback.call(message, code);
  }
}
