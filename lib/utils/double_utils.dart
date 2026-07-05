import 'package:mini_home/core/themes/strings.dart';
import 'package:intl/intl.dart';
import 'dart:math';

extension DoubleUtils on double? {
  /// 秒数を時・分・秒のフォーマットに変換
  String formatDuration() {
    if (this == null) return AppStrings.timeCharging(0, 0, 0);
    int secondsInt = this!.toInt();
    int hours = secondsInt ~/ 3600;
    int minutes = (secondsInt % 3600) ~/ 60;
    int remainingSeconds = secondsInt % 60;
    return AppStrings.timeCharging(hours, minutes, remainingSeconds);
  }

  /// 整数なら小数点なし、小数ならそのままのシンプルな文字列に変換
  String toSimpleNumberString() {
    if (this == null) return "0";
    return (this! % 1 == 0) ? this!.toInt().toString() : this!.toString();
  }

  /// 指定した小数点以下の桁数で切り上げ
  double ceilToPrecision(int decimalPlaces) {
    if (this == null) return 0.0;
    final factor = pow(10, decimalPlaces);
    return (this! * factor).ceil() / factor;
  }

  /// 整数なら小数点なし、小数ならそのまま。カンマ区切りで返す。
  String toCommaSeparatedString() {
    if (this == null) return "0";

    final double value = this!;
    final bool isInteger = value % 1 == 0;

    final formatter = NumberFormat("#,##0${isInteger ? '' : '.###'}");
    return formatter.format(value);
  }
}
