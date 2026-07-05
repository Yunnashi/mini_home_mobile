import 'package:flutter/foundation.dart';

void safeDebugPrint(String? message) {
  if (kDebugMode && message != null) {
    debugPrint(message);
  }
}
