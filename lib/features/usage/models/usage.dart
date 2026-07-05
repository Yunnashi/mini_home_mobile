import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage.freezed.dart';
part 'usage.g.dart';

// NOTO: Device modelの定義とパラメータの定義が合わないので別途定義している
@freezed
abstract class UsageDevice with _$UsageDevice {
  const factory UsageDevice({
    required int id,
    required String deviceId, // 実際はexternalDeviceId
    String? nickname,
  }) = _UsageDevice;

  factory UsageDevice.fromJson(Map<String, dynamic> json) =>
      _$UsageDeviceFromJson(json);
}

@freezed
abstract class Usage with _$Usage {
  const factory Usage({
    required int id,
    required UsageDevice device,
    String? startedAt,
    String? finishedAt,
    required bool isFinalized,
    required double kwHour,
    required int chargingSeconds,
    required String? createdAt,
    required String? updatedAt,
  }) = _Usage;

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);
}
