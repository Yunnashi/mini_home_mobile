import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';

class BasicButton {
  static final BasicButton _instance = BasicButton._internal();

  factory BasicButton() {
    return _instance;
  }

  BasicButton._internal();

  // 文字数に合わせてwidthを調整するボタン、メインではないactionボタンなどで使用
  static CustomButton buildSmall(
      {required String text,
      Color color = AppColors.primary,
      ButtonType buttonType = ButtonType.contained,
      ShapeType shapeType = ShapeType.square,
      required Function() onPressed}) {
    final TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: buttonType == ButtonType.contained ? AppColors.white : color,
    );

    return CustomButton(
      text: text,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: 100,
      borderRadius: shapeType == ShapeType.rounded ? 30 : 4,
      backgroundColor:
          buttonType == ButtonType.contained ? color : Colors.transparent,
      textColor: buttonType == ButtonType.contained ? AppColors.white : color,
      textStyle: textStyle, // ここで TextStyle オブジェクトを直接渡す
      buttonType: buttonType,
      onPressed: onPressed,
    );
  }

  // width固定のボタン
  static CustomButton buildLarge(
      {required String text,
      Color color = AppColors.primary,
      ButtonType buttonType = ButtonType.contained,
      ShapeType shapeType = ShapeType.rounded,
      EdgeInsetsGeometry? padding,
      required Function() onPressed}) {
    final TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      letterSpacing: 0.5,
      color: buttonType == ButtonType.contained ? AppColors.white : color,
    );

    return CustomButton(
      text: text,
      width: null,
      borderRadius: shapeType == ShapeType.rounded ? 30 : 4,
      backgroundColor:
          buttonType == ButtonType.contained ? color : Colors.transparent,
      textColor: buttonType == ButtonType.contained ? AppColors.white : color,
      textStyle: textStyle, // ここで TextStyle オブジェクトを直接渡す
      buttonType: buttonType,
      padding: padding,
      onPressed: onPressed,
    );
  }
}
