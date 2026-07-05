// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsageDevice _$UsageDeviceFromJson(Map<String, dynamic> json) => _UsageDevice(
      id: (json['id'] as num).toInt(),
      deviceId: json['deviceId'] as String,
      nickname: json['nickname'] as String?,
    );

Map<String, dynamic> _$UsageDeviceToJson(_UsageDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'nickname': instance.nickname,
    };

_Usage _$UsageFromJson(Map<String, dynamic> json) => _Usage(
      id: (json['id'] as num).toInt(),
      device: UsageDevice.fromJson(json['device'] as Map<String, dynamic>),
      startedAt: json['startedAt'] as String?,
      finishedAt: json['finishedAt'] as String?,
      isFinalized: json['isFinalized'] as bool,
      kwHour: (json['kwHour'] as num).toDouble(),
      chargingSeconds: (json['chargingSeconds'] as num).toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$UsageToJson(_Usage instance) => <String, dynamic>{
      'id': instance.id,
      'device': instance.device,
      'startedAt': instance.startedAt,
      'finishedAt': instance.finishedAt,
      'isFinalized': instance.isFinalized,
      'kwHour': instance.kwHour,
      'chargingSeconds': instance.chargingSeconds,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
