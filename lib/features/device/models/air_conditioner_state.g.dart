// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_conditioner_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AirConditionerState _$AirConditionerStateFromJson(Map<String, dynamic> json) =>
    _AirConditionerState(
      targetTemperature: (json['targetTemperature'] as num?)?.toInt() ?? 24,
      mode: $enumDecodeNullable(_$AirConditionerModeEnumMap, json['mode']) ??
          AirConditionerMode.auto,
      fanSpeed: $enumDecodeNullable(_$FanSpeedEnumMap, json['fanSpeed']) ??
          FanSpeed.auto,
    );

Map<String, dynamic> _$AirConditionerStateToJson(
        _AirConditionerState instance) =>
    <String, dynamic>{
      'targetTemperature': instance.targetTemperature,
      'mode': _$AirConditionerModeEnumMap[instance.mode]!,
      'fanSpeed': _$FanSpeedEnumMap[instance.fanSpeed]!,
    };

const _$AirConditionerModeEnumMap = {
  AirConditionerMode.auto: 'auto',
  AirConditionerMode.cooling: 'cooling',
  AirConditionerMode.heating: 'heating',
  AirConditionerMode.fan: 'fan',
};

const _$FanSpeedEnumMap = {
  FanSpeed.auto: 'auto',
  FanSpeed.low: 'low',
  FanSpeed.medium: 'medium',
  FanSpeed.high: 'high',
};
