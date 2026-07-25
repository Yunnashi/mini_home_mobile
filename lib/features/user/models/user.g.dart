// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      defaultHomeId: (json['defaultHomeId'] as num?)?.toInt(),
      userGroups: (json['userGroups'] as List<dynamic>?)
          ?.map((e) => UserGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'defaultHomeId': instance.defaultHomeId,
      'userGroups': instance.userGroups,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
