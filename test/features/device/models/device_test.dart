import 'package:flutter_test/flutter_test.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/device_type.dart';

void main() {
  group('Device JSON', () {
    test('parses a light', () {
      final device = Device.fromJson({
        'id': 1,
        'externalDeviceId': 'demo-light-1',
        'homeId': 1,
        'roomId': 1,
        'name': 'Living room light',
        'type': 'light',
        'isOnline': true,
        'isPowerOn': true,
        'lightState': {'brightness': 70, 'colorTemperature': 4200},
      });

      expect(device.type, DeviceType.light);
      expect(device.lightState?.brightness, 70);
      expect(device.nickname, 'Living room light');
    });

    test('parses an air conditioner', () {
      final device = Device.fromJson({
        'id': 2,
        'externalDeviceId': 'demo-ac-1',
        'homeId': 1,
        'roomId': 1,
        'name': 'Living room AC',
        'type': 'airConditioner',
        'isOnline': false,
        'isPowerOn': false,
        'airConditionerState': {
          'targetTemperature': 24,
          'mode': 'cooling',
          'fanSpeed': 'auto',
        },
      });

      expect(device.type, DeviceType.airConditioner);
      expect(device.airConditionerState?.targetTemperature, 24);
      expect(device.isOffline, isTrue);
    });
  });
}
