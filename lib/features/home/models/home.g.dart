// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Home _$HomeFromJson(Map<String, dynamic> json) => _Home(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      summary: json['summary'] == null
          ? null
          : HomeSummary.fromJson(json['summary'] as Map<String, dynamic>),
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Room>[],
    );

Map<String, dynamic> _$HomeToJson(_Home instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'summary': instance.summary,
      'rooms': instance.rooms,
    };
