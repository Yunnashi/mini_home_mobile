import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyle {
  static final AppTextStyle _instance = AppTextStyle._internal();

  factory AppTextStyle() {
    return _instance;
  }

  AppTextStyle._internal() {
    // initialization logic
  }

  // 半角、全角混ざりでギザギザ対策
  static const _decorationSafeFontFamily = 'Hiragino Kaku Gothic ProN';

  static const TextStyle placeHolder = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: AppColors.placeholder,
      letterSpacing: 0.5);

  //Basic - heading
  static const TextStyle heading0 = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 20,
      letterSpacing: 0.5,
      color: AppColors.text);

  static const TextStyle heading1 = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      letterSpacing: 1.0,
      color: AppColors.text);

  static const TextStyle heading2 = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.text);

  static const TextStyle heading3 = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.text);

  //Basic - heading standards
  static const TextStyle heading0TextWhite = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 20,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle heading0TextGrey = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 20,
      color: AppColors.greyText,
      letterSpacing: 0.5);

  static const TextStyle heading1TextWhite = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle heading1TextGrey = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: AppColors.greyText,
      letterSpacing: 0.5);

  static const TextStyle heading2TextPrimary = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.primary);

  static const TextStyle heading2TextWhite = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle heading2TextGrey = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      color: AppColors.greyText,
      letterSpacing: 0.5);

  static const TextStyle heading3TextWhite = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle heading3TextGrey = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      color: AppColors.greyText,
      letterSpacing: 0.5);

  static const TextStyle heading4TextWhite = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 10,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle heading4TextGrey = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 10,
      color: AppColors.greyText,
      letterSpacing: 0.5);

  //Basic - body
  static const TextStyle body0 = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 20,
      letterSpacing: 0.5,
      color: AppColors.text);

  //Basic - body standards
  static const TextStyle body1 = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: AppColors.text,
      letterSpacing: 0.5);

  static const TextStyle body2 = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.text);

  static const TextStyle body3 = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.text);

  static const TextStyle body4 = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 10,
      letterSpacing: 0.5,
      color: AppColors.text);

  static const TextStyle body0TextGrey = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 20,
      letterSpacing: 0.5,
      color: AppColors.greyText);

  static const TextStyle body1TextWhite = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: AppColors.whiteText,
      letterSpacing: 0.5);

  static const TextStyle body1TextGrey = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: AppColors.greyText,
      letterSpacing: 0.5);

  static const TextStyle body2TextWhite = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle body2TextGrey = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.greyText);

  static const TextStyle body3TextWhite = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle body3TextGrey = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.greyText);

  static const TextStyle body3WithLineThrough = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.text,
      fontFamily: _decorationSafeFontFamily,
      decoration: TextDecoration.lineThrough);

  static const TextStyle body4TextWhite = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 10,
      letterSpacing: 0.5,
      color: AppColors.whiteText);

  static const TextStyle body4TextGrey = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 10,
      letterSpacing: 0.5,
      color: AppColors.greyText);

  //Custom - heading
  static const TextStyle heading0Primary = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 20,
      letterSpacing: 0.5,
      color: AppColors.primary);

  static const TextStyle heading1TextAccent = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      letterSpacing: 0.5,
      color: AppColors.secondary);

  static const TextStyle heading3TextPrimary = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      color: AppColors.primary,
      letterSpacing: 0.5);

  static const TextStyle heading3TextRed = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      color: AppColors.red,
      letterSpacing: 0.5);

  //Custom - body
  static const TextStyle body1TextRed = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: AppColors.red,
      letterSpacing: 0.5);

  static const TextStyle body1UnderLine = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    letterSpacing: 0.5,
    color: AppColors.link,
    decoration: TextDecoration.underline,
    fontFamily: _decorationSafeFontFamily,
  );

  static const TextStyle body1TextPrimary = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 16,
      letterSpacing: 0.5,
      color: AppColors.primary);

  static const TextStyle body2TextUnderLine = TextStyle(
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    letterSpacing: 0.5,
    color: AppColors.link,
    fontFamily: _decorationSafeFontFamily,
  );

  static const TextStyle body2TextPrimary = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.primary);

  static const TextStyle body3TextLink = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.link);

  static const TextStyle body3TextRed = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.red);
}
