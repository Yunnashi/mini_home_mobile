// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeSummary _$HomeSummaryFromJson(Map<String, dynamic> json) => _HomeSummary(
      activeDeviceCount: (json['activeDeviceCount'] as num?)?.toInt(),
      indoorTemperature: (json['indoorTemperature'] as num?)?.toInt(),
      todayEnergyKwh: (json['todayEnergyKwh'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeSummaryToJson(_HomeSummary instance) =>
    <String, dynamic>{
      'activeDeviceCount': instance.activeDeviceCount,
      'indoorTemperature': instance.indoorTemperature,
      'todayEnergyKwh': instance.todayEnergyKwh,
    };
