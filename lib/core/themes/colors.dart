import 'dart:ui';

class AppColors {
  static final AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  AppColors._internal() {
    // initialization logic
  }
  static const Color primary = Color(0xFF26A69A);
  static const Color primaryContainer = Color(0xFFE7F6F4);

  static const Color secondary = Color(0xFFFF9800);

  static const Color text = Color(0xFF1D2939);
  static const Color greyText = Color(0xFF667085);
  static const Color whiteText = Color(0xFFFFFFFF);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF595B6F);
  static const Color lightGrey = Color(0xFFF4F4F4);
  static const Color lightBlue = Color(0xFFCFDAEE);
  static const Color green = Color(0xFF34A853);
  static const Color lightGreen = Color(0xFFECF8F8);
  static const Color red = Color(0xFFEB4331);
  static const Color lightRed = Color(0xFFFFE5E0);
  static const Color orange = Color(0xFFFF9800);
  static const Color lightOrange = Color(0xFFFFEACC);

  static const Color link = Color(0xFF236EAC);
  static const Color placeholder = Color(0xFFAAAAAA);
  static const Color border = Color(0xFFEAECF0);
  static const Color background = Color(0xFFF6F8FA);
  static const Color lightAccent = Color(0xFFFFB547);
  static const Color airConditioner = Color(0xFF4A90E2);
}
