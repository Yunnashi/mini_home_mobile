import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/core/themes/strings.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
abstract class Schedule with _$Schedule {
  const factory Schedule({
    required String id,
    required String startAt,
    required String finishAt,
    required bool isEndsNextDay,
    required List<Weekday> weekdays,
    required bool isEnabled,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}

enum Weekday {
  @JsonValue('SUN')
  sun,
  @JsonValue('MON')
  mon,
  @JsonValue('TUE')
  tue,
  @JsonValue('WED')
  wed,
  @JsonValue('THU')
  thu,
  @JsonValue('FRI')
  fri,
  @JsonValue('SAT')
  sat;

  String get displayName {
    switch (this) {
      case Weekday.sun:
        return AppStrings.sunday;
      case Weekday.mon:
        return AppStrings.monday;
      case Weekday.tue:
        return AppStrings.tuesday;
      case Weekday.wed:
        return AppStrings.wednesday;
      case Weekday.thu:
        return AppStrings.thursday;
      case Weekday.fri:
        return AppStrings.friday;
      case Weekday.sat:
        return AppStrings.saturday;
    }
  }

  /// 曜日の順序を取得する（日曜日を0とする）
  int get order {
    switch (this) {
      case Weekday.sun:
        return 0;
      case Weekday.mon:
        return 1;
      case Weekday.tue:
        return 2;
      case Weekday.wed:
        return 3;
      case Weekday.thu:
        return 4;
      case Weekday.fri:
        return 5;
      case Weekday.sat:
        return 6;
    }
  }
}

extension WeekdayListExtension on List<Weekday> {
  /// スケジュールの頻度の表示タイプ
  ScheduleFrequencyType get frequencyType {
    // 毎日の場合
    if (length == 7) {
      return ScheduleFrequencyType.daily;
    }

    // 平日の場合
    if (length == 5 &&
        contains(Weekday.mon) &&
        contains(Weekday.tue) &&
        contains(Weekday.wed) &&
        contains(Weekday.thu) &&
        contains(Weekday.fri)) {
      return ScheduleFrequencyType.weekday;
    }

    // その他の場合
    return ScheduleFrequencyType.custom;
  }

  String get frequencyDisplayString {
    switch (frequencyType) {
      case ScheduleFrequencyType.daily:
        return AppStrings.daily;
      case ScheduleFrequencyType.weekday:
        return AppStrings.weekday;
      case ScheduleFrequencyType.custom:
        // その他の場合は曜日を列挙（順序でソート）
        final sortedWeekdays = [...this]
          ..sort((a, b) => a.order.compareTo(b.order));
        return "${AppStrings.everyWeek}  ${sortedWeekdays.map((w) => w.displayName).join('、')}";
    }
  }
}

extension WeekdaySetExtension on Set<Weekday> {
  /// スケジュールの頻度の表示タイプ
  ScheduleFrequencyType get frequencyType => toList().frequencyType;

  /// スケジュール頻度の表示文字列を取得する
  String get frequencyDisplayString => toList().frequencyDisplayString;
}

/// スケジュールの頻度タイプ
enum ScheduleFrequencyType {
  daily,
  weekday,
  custom,
}
