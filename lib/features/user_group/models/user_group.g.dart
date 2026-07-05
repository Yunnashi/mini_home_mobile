// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserGroup _$UserGroupFromJson(Map<String, dynamic> json) => _UserGroup(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      devices: _devicesFromJson(json['devices'] as List?),
    );

Map<String, dynamic> _$UserGroupToJson(_UserGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'devices': _devicesToJson(instance.devices),
    };
