import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/features/device/models/device_type.dart';
import 'package:mini_home/features/device/models/light_state.dart';
import 'package:mini_home/features/device/models/air_conditioner_state.dart';
import 'package:mini_home/features/device/models/fw_update_status.dart';

part 'device.freezed.dart';
part 'device.g.dart';

@freezed
sealed class Device with _$Device {
  const Device._();

  const factory Device(
      {required int id,
      required String externalDeviceId,
      @Default(1) int homeId,
      @Default(1) int roomId,
      String? name,
      @Default(DeviceType.light) DeviceType type,
      @Default(true) bool isOnline,
      @Default(false) bool isPowerOn,
      LightState? lightState,
      AirConditionerState? airConditionerState,
      String? nickname,
      double? temperature,
      String? mode,
      @Default(false) bool isOffline,
      String? fwVersion,
      DateTime? lastPingedAt}) = _Device;

  bool get hasDeviceError => isOffline == true || isOnline == false;

  FwUpdateStatus fwStatus(String latestFwVersion, [bool? isUpdating]) {
    return FwUpdateStatus.fromFwVersion(fwVersion, latestFwVersion, isUpdating);
  }

  factory Device.fromJson(Map<String, dynamic> json) =>
      _$DeviceFromJson(_withOfflineState(json));

  static Map<String, dynamic> _withOfflineState(Map<String, dynamic> json) => {
        ...json,
        'nickname': json['nickname'] ?? json['name'],
        'isOffline': json['isOffline'] ?? json['isOnline'] == false,
      };

  @override
  Map<String, dynamic> toJson() => _$DeviceToJson(this as _Device);
}
