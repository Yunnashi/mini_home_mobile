// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
      id: json['id'] as String,
      startAt: json['startAt'] as String,
      finishAt: json['finishAt'] as String,
      isEndsNextDay: json['isEndsNextDay'] as bool,
      weekdays: (json['weekdays'] as List<dynamic>)
          .map((e) => $enumDecode(_$WeekdayEnumMap, e))
          .toList(),
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'startAt': instance.startAt,
      'finishAt': instance.finishAt,
      'isEndsNextDay': instance.isEndsNextDay,
      'weekdays': instance.weekdays.map((e) => _$WeekdayEnumMap[e]!).toList(),
      'isEnabled': instance.isEnabled,
    };

const _$WeekdayEnumMap = {
  Weekday.sun: 'SUN',
  Weekday.mon: 'MON',
  Weekday.tue: 'TUE',
  Weekday.wed: 'WED',
  Weekday.thu: 'THU',
  Weekday.fri: 'FRI',
  Weekday.sat: 'SAT',
};
