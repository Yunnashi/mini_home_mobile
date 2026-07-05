import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';

enum ToastType { success, info, error, warning }

class BasicToast {
  static final BasicToast _instance = BasicToast._internal();
  static final Set<String> _openToasts = {};

  factory BasicToast() {
    return _instance;
  }

  BasicToast._internal();

  static showToast(String message, ToastType type,
      {Toast toastLength = Toast.LENGTH_SHORT}) async {
    if (_openToasts.contains(message)) return; // 同じメッセージのトーストが表示中ならreturn
    _openToasts.add(message);

    Color backgroundColor;
    final int seconds = toastLength == Toast.LENGTH_LONG ? 5 : 1;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.green.withValues(alpha: 0.95);
        break;
      case ToastType.info:
        backgroundColor = AppColors.grey.withValues(alpha: 0.95);
        break;
      case ToastType.error:
        backgroundColor = AppColors.red.withValues(alpha: 0.95);
        break;
      case ToastType.warning:
        backgroundColor = AppColors.orange.withValues(alpha: 0.95);
        break;
    }

    await Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength, // Android用
      timeInSecForIosWeb: seconds, // iOS用
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: AppColors.white,
      fontSize: AppTextStyle.body1.fontSize,
    );

    // トースト表示後にメッセージを削除
    Future.delayed(
      Duration(seconds: seconds),
      () => _openToasts.remove(message),
    );
  }
}
