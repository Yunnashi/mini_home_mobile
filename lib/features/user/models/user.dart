import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/features/user_group/models/user_group.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,
    int? defaultHomeId,
    // Legacy compatibility for locally cached users created before miniHome.
    List<UserGroup>? userGroups,
    String? createdAt,
    String? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
