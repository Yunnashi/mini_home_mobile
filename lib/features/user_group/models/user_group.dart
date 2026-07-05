import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/features/device/models/device.dart';

part 'user_group.freezed.dart';
part 'user_group.g.dart';

@freezed
abstract class UserGroup with _$UserGroup {
  const factory UserGroup({
    required int id,
    String? name,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
    List<Device>? devices,
  }) = _UserGroup;

  factory UserGroup.fromJson(Map<String, dynamic> json) =>
      _$UserGroupFromJson(json);
}

List<Device>? _devicesFromJson(List<dynamic>? json) {
  if (json == null) return null;
  return json.map((e) => Device.fromJson(e as Map<String, dynamic>)).toList();
}

List<Map<String, dynamic>>? _devicesToJson(List<Device>? devices) {
  if (devices == null) return null;
  return devices.map((e) => e.toJson()).toList();
}
