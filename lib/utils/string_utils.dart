/// Stringに関する処理の拡張機能
import 'package:easy_localization/easy_localization.dart';

enum FormatType {
  fullWithSeconds("commons.formats.datetime.full_with_seconds"),
  fullWithoutSeconds("commons.formats.datetime.full_without_seconds"),
  dateOnly("commons.formats.datetime.date_only"),
  monthDayWithSeconds("commons.formats.datetime.month_day_with_seconds"),
  monthDayWithoutSeconds("commons.formats.datetime.month_day_without_seconds"),
  monthDayOnly("commons.formats.datetime.month_day_only"),
  yearMonthOnly("commons.formats.datetime.year_month_only");

  final String key;
  const FormatType(this.key);
}

extension StringUtils on String? {
  bool get isNullOrEmpty => this == null || this == "";

  String formatDateTimeText({
    FormatType type = FormatType.fullWithSeconds,
    String defaultValue = "No Data",
  }) {
    if (isNullOrEmpty) {
      return defaultValue;
    }

    try {
      final original = this!;
      final dateFormatFirst = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ");
      final parsedDate = dateFormatFirst.parse(original);

      // 🔽 翻訳ファイルから format string を取得
      final localizedFormat = type.key.tr();
      final dateFormatSecond = DateFormat(localizedFormat);

      return dateFormatSecond.format(parsedDate);
    } catch (e) {
      return defaultValue;
    }
  }
}
