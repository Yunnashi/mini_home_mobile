// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LightState _$LightStateFromJson(Map<String, dynamic> json) => _LightState(
      brightness: (json['brightness'] as num?)?.toInt() ?? 50,
      colorTemperature: (json['colorTemperature'] as num?)?.toInt() ?? 4000,
    );

Map<String, dynamic> _$LightStateToJson(_LightState instance) =>
    <String, dynamic>{
      'brightness': instance.brightness,
      'colorTemperature': instance.colorTemperature,
    };
