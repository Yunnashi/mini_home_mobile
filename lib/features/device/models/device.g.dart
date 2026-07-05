// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Device _$DeviceFromJson(Map<String, dynamic> json) => _Device(
      id: (json['id'] as num).toInt(),
      externalDeviceId: json['externalDeviceId'] as String,
      nickname: json['nickname'] as String?,
      chargingAmpere: (json['chargingAmpere'] as num?)?.toDouble(),
      maxChargingAmpere: (json['maxChargingAmpere'] as num?)?.toDouble(),
      evseState: const EvseStateConverter()
          .fromJson((json['evseState'] as num).toInt()),
      ellaState: const EllaStateConverter()
          .fromJson((json['ellaState'] as num).toInt()),
      temperature: (json['temperature'] as num?)?.toDouble(),
      mode: json['mode'] as String?,
      isOffline: json['isOffline'] as bool? ?? false,
      cplt: json['cplt'] as bool,
      model: $enumDecode(_$DeviceModelEnumMap, json['model']),
      fwVersion: json['fwVersion'] as String?,
      lastPingedAt: json['lastPingedAt'] == null
          ? null
          : DateTime.parse(json['lastPingedAt'] as String),
    );

Map<String, dynamic> _$DeviceToJson(_Device instance) => <String, dynamic>{
      'id': instance.id,
      'externalDeviceId': instance.externalDeviceId,
      'nickname': instance.nickname,
      'chargingAmpere': instance.chargingAmpere,
      'maxChargingAmpere': instance.maxChargingAmpere,
      'evseState': const EvseStateConverter().toJson(instance.evseState),
      'ellaState': const EllaStateConverter().toJson(instance.ellaState),
      'temperature': instance.temperature,
      'mode': instance.mode,
      'isOffline': instance.isOffline,
      'cplt': instance.cplt,
      'model': _$DeviceModelEnumMap[instance.model]!,
      'fwVersion': instance.fwVersion,
      'lastPingedAt': instance.lastPingedAt?.toIso8601String(),
    };

const _$DeviceModelEnumMap = {
  DeviceModel.legacyElla: 'LEGACY_ELLA',
  DeviceModel.ella: 'ELLA',
  DeviceModel.industrial: 'INDUSTRIAL',
  DeviceModel.nadiya: 'NADIYA',
};
