import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static final Loading _instance = Loading._internal();

  factory Loading() {
    return _instance;
  }

  Loading._internal();

  void show() {
    EasyLoading.show();
  }

  void showSuccess(String content) {
    EasyLoading.showSuccess(content);
  }

  void dismiss() {
    EasyLoading.dismiss();
  }

  void dismissWith({required Duration delay, VoidCallback? complete}) {
    Future.delayed(delay).then((value) {
      dismiss();
      complete?.call();
    });
  }

  void showWithValue(String value) {
    EasyLoading.show(status: value);
    // Timer(const Duration(seconds: 3), () {
    //   dismiss();
    // });
  }

  void showError(String value) {
    EasyLoading.showError(value);
  }
}
