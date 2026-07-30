import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_home/core/themes/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.white,
      error: AppColors.red,
    ),
    dividerColor: AppColors.border,
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.primaryContainer,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.12),
      activeTickMarkColor: AppColors.white,
      inactiveTickMarkColor: AppColors.primary.withValues(alpha: 0.35),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: const TextStyle(color: AppColors.whiteText),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AppColors.border),
      ),
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light),
      elevation: 0,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.text,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: AppColors.border),
      ),
    ),
  );
}
