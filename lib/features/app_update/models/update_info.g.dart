// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateInfo _$UpdateInfoFromJson(Map<String, dynamic> json) => _UpdateInfo(
      latestVersion: json['latestVersion'] as String?,
      requiredVersion: json['requiredVersion'] as String?,
      enabledAt: json['enabledAt'] as String?,
    );

Map<String, dynamic> _$UpdateInfoToJson(_UpdateInfo instance) =>
    <String, dynamic>{
      'latestVersion': instance.latestVersion,
      'requiredVersion': instance.requiredVersion,
      'enabledAt': instance.enabledAt,
    };
