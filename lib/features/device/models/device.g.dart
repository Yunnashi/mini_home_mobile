// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Device _$DeviceFromJson(Map<String, dynamic> json) => _Device(
      id: (json['id'] as num).toInt(),
      externalDeviceId: json['externalDeviceId'] as String,
      homeId: (json['homeId'] as num?)?.toInt() ?? 1,
      roomId: (json['roomId'] as num?)?.toInt() ?? 1,
      name: json['name'] as String?,
      type: $enumDecodeNullable(_$DeviceTypeEnumMap, json['type']) ??
          DeviceType.light,
      isOnline: json['isOnline'] as bool? ?? true,
      isPowerOn: json['isPowerOn'] as bool? ?? false,
      lightState: json['lightState'] == null
          ? null
          : LightState.fromJson(json['lightState'] as Map<String, dynamic>),
      airConditionerState: json['airConditionerState'] == null
          ? null
          : AirConditionerState.fromJson(
              json['airConditionerState'] as Map<String, dynamic>),
      nickname: json['nickname'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      mode: json['mode'] as String?,
      isOffline: json['isOffline'] as bool? ?? false,
      fwVersion: json['fwVersion'] as String?,
      lastPingedAt: json['lastPingedAt'] == null
          ? null
          : DateTime.parse(json['lastPingedAt'] as String),
    );

Map<String, dynamic> _$DeviceToJson(_Device instance) => <String, dynamic>{
      'id': instance.id,
      'externalDeviceId': instance.externalDeviceId,
      'homeId': instance.homeId,
      'roomId': instance.roomId,
      'name': instance.name,
      'type': _$DeviceTypeEnumMap[instance.type]!,
      'isOnline': instance.isOnline,
      'isPowerOn': instance.isPowerOn,
      'lightState': instance.lightState,
      'airConditionerState': instance.airConditionerState,
      'nickname': instance.nickname,
      'temperature': instance.temperature,
      'mode': instance.mode,
      'isOffline': instance.isOffline,
      'fwVersion': instance.fwVersion,
      'lastPingedAt': instance.lastPingedAt?.toIso8601String(),
    };

const _$DeviceTypeEnumMap = {
  DeviceType.light: 'light',
  DeviceType.airConditioner: 'airConditioner',
};
