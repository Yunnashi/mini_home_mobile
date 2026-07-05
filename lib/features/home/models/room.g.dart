// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayOrder': instance.displayOrder,
    };
