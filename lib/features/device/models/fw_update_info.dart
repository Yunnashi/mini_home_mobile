import 'package:freezed_annotation/freezed_annotation.dart';

part 'fw_update_info.freezed.dart';
part 'fw_update_info.g.dart';

@freezed
abstract class FwUpdateInfo with _$FwUpdateInfo {
  const factory FwUpdateInfo({
    /// 最新ファームウェアバージョン
    String? latestVersion,
  }) = _FwUpdateInfo;

  factory FwUpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$FwUpdateInfoFromJson(json);
}
