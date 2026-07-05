import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_info.freezed.dart';
part 'update_info.g.dart';

@freezed
abstract class UpdateInfo with _$UpdateInfo {
  const factory UpdateInfo({
    /// 要求バージョン（任意）
    String? latestVersion,

    /// 要求バージョン（強制）
    String? requiredVersion,

    /// RemoteConfigが有効になる日時
    String? enabledAt,
  }) = _UpdateInfo;

  factory UpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$UpdateInfoFromJson(json);
}
