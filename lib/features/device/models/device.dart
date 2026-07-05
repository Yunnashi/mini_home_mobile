import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/features/device/models/device_model.dart';
import 'package:mini_home/features/device/models/device_status.dart';
import 'package:mini_home/features/device/models/ella_state.dart';
import 'package:mini_home/features/device/models/evse_state.dart';
import 'package:mini_home/features/device/models/fw_update_status.dart';

part 'device.freezed.dart';
part 'device.g.dart';

@freezed
sealed class Device with _$Device {
  const Device._();

  const factory Device(
      {required int id,
      required String externalDeviceId,
      String? nickname,
      double? chargingAmpere,
      double? maxChargingAmpere,
      @EvseStateConverter() required EvseState evseState,
      @EllaStateConverter() required EllaState ellaState,
      double? temperature,
      String? mode,
      @Default(false) bool isOffline,
      required bool cplt,
      required DeviceModel model,
      String? fwVersion,
      DateTime? lastPingedAt}) = _Device;

  double? get chargingKw {
    if (chargingAmpere == null) {
      return null;
    }
    return chargingAmpere!.toKw();
  }

  bool get hasChargingError =>
      evseState == EvseState.error1 ||
      evseState == EvseState.error2 ||
      evseState == EvseState.error3 ||
      isOffline == true;

  DeviceStatus get status => DeviceStatus.fromEvseStateAndCplt(
        evseState,
        ellaState,
        cplt,
        isOffline,
      );
  // 旧EllaはFW更新不可とし、それ以外はfw_versionを用いて判断させる。
  FwUpdateStatus fwStatus(String latestFwVersion, [bool? isUpdating]) {
    if (model == DeviceModel.legacyElla) {
      return FwUpdateStatus.unknown;
    }
    return FwUpdateStatus.fromFwVersion(fwVersion, latestFwVersion, isUpdating);
  }

  bool get isRebootable => model != DeviceModel.legacyElla;

  factory Device.fromJson(Map<String, dynamic> json) =>
      _$DeviceFromJson(_withOfflineState(json));

  static Map<String, dynamic> _withOfflineState(Map<String, dynamic> json) {
    // 暫定対応：アプリ側でlastPingedAt と evseState/ellaState を使ってオフライン判定
    final evseState =
        const EvseStateConverter().fromJson((json['evseState'] as num).toInt());
    final ellaState =
        const EllaStateConverter().fromJson((json['ellaState'] as num).toInt());
    final lastPingedAt = json['lastPingedAt'] == null
        ? null
        : DateTime.parse(json['lastPingedAt'] as String);
    final modifiedJson = {
      ...json,
      'isOffline': _isOffline(evseState, ellaState, lastPingedAt),
    };
    return modifiedJson;
  }

  Map<String, dynamic> toJson() => _$DeviceToJson(this as _Device);

  static bool _isOffline(
      EvseState evseState, EllaState ellaState, DateTime? lastPingedAt) {
    if (lastPingedAt == null) {
      return true;
    }

    // OTA中の時 : コマンド受信からLTEだと10分前後かかってしまうため
    if (ellaState == EllaState.otaInProgress) {
      return lastPingedAt
          .isBefore(DateTime.now().subtract(const Duration(minutes: 15)));
    }

    // StateAの時
    if (evseState == EvseState.disconnected) {
      return lastPingedAt
          .isBefore(DateTime.now().subtract(const Duration(minutes: 6)));
    }

    return lastPingedAt
        .isBefore(DateTime.now().subtract(const Duration(minutes: 1)));
  }
}

extension ChargingConversion on double {
  /// kW → Ampere (1kW = 5A)
  double toAmpere() => (this * 5).roundToDouble();

  /// Ampere → kW (1kW = 5A)
  double toKw() => (this / 5);
}
