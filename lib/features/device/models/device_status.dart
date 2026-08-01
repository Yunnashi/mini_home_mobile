import 'dart:ui';

import 'package:mini_home/core/themes/strings.dart';

enum DeviceStatus {
  disconnected('disconnected', Color(0xFF0F80D8)),
  connected('connected', Color(0xFF00D0D0)),
  chargingStopped('charging_stopped', Color(0xFF00D0D0)),
  charging('charging', Color(0xFF00CA2C)),
  error('error', Color(0xFFEA0000)),
  otaInProgress('ota_in_progress', Color(0xFFFF9800)),
  offline('offline', Color(0xFF595B6F)),
  unknown('unknown', Color(0xFF3F3F3F));

  const DeviceStatus(this.key, this.color);

  final String key;
  final Color color;

  String get label {
    switch (this) {
      case DeviceStatus.disconnected:
        return AppStrings.deviceStatusDisconnected;
      case DeviceStatus.connected:
        return AppStrings.deviceStatusConnected;
      case DeviceStatus.chargingStopped:
        return AppStrings.deviceStatusChargingStopped;
      case DeviceStatus.charging:
        return AppStrings.deviceStatusCharging;
      case DeviceStatus.error:
        return AppStrings.deviceStatusError;
      case DeviceStatus.otaInProgress:
        return AppStrings.deviceStatusOtaInProgress;
      case DeviceStatus.offline:
        return AppStrings.deviceStatusOffline;
      case DeviceStatus.unknown:
        return AppStrings.deviceStatusUnknown;
    }
  }

  static DeviceStatus fromDeviceState({
    required bool isOnline,
    required bool isPowerOn,
    required bool isOffline,
  }) {
    if (isOffline || !isOnline) {
      return DeviceStatus.offline;
    }
    if (isPowerOn) {
      return DeviceStatus.charging;
    }
    return DeviceStatus.connected;
  }
}
