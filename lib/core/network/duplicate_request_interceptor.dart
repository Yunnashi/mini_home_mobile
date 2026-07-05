import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:mini_home/core/constants/custom_errors.dart';

/// リクエストの重複を防ぐインターセプター
class DuplicateRequestInterceptor extends Interceptor {
  static final DuplicateRequestInterceptor _instance =
      DuplicateRequestInterceptor._internal();
  factory DuplicateRequestInterceptor() => _instance;
  DuplicateRequestInterceptor._internal();

  final _pendingRequests = HashSet<String>();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final key = _generateRequestKey(options);

    // 同じリクエストが進行中の場合はキャンセル
    if (_pendingRequests.contains(key)) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: AppCustomErrors.duplicateRequestError.code,
        ),
      );
      return;
    }

    _pendingRequests.add(key);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final key = _generateRequestKey(response.requestOptions);
    _pendingRequests.remove(key);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final key = _generateRequestKey(err.requestOptions);
    _pendingRequests.remove(key);
    handler.next(err);
  }

  String _generateRequestKey(RequestOptions options) {
    return '${options.method}_${options.path}_${options.data}_${options.queryParameters}';
  }
}
