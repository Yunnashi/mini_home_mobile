import 'package:dio/dio.dart';
import 'package:mini_home/utils/logger.dart';

extension PrintResponseAPI on Response {
  void printResponse() {
    safeDebugPrint("Request:");
    safeDebugPrint(
        "${requestOptions.method} ${requestOptions.baseUrl}${requestOptions.path}");
    safeDebugPrint("Header:");
    safeDebugPrint(requestOptions.headers.toString());
    if (requestOptions.queryParameters.isNotEmpty) {
      safeDebugPrint("Query Parameters:");
      safeDebugPrint(requestOptions.queryParameters.toString());
    }
    if (requestOptions.data != null) {
      safeDebugPrint("Body:");
      safeDebugPrint(requestOptions.data.toString());
    }
    safeDebugPrint("Response: --------- Status code: $statusCode");
    safeDebugPrint(data.toString());
  }
}
