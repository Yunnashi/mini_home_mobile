import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/device/models/air_conditioner_state.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/light_state.dart';
import 'package:mini_home/features/device/repositories/device_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'smart_device_service.g.dart';

@riverpod
class SmartDeviceService extends _$SmartDeviceService {
  static const int demoHomeId = 1;

  @override
  Future<Device> build(int deviceId) => _fetch(deviceId);

  Future<Device> _fetch(int deviceId) async {
    final result = await ref.read(deviceRepositoryProvider).getSmartDevice(
          homeId: demoHomeId,
          deviceId: deviceId,
        );
    if (result case Success(value: final value)) {
      return Device.fromJson(value as Map<String, dynamic>);
    }
    throw Exception(result is Failure ? result.message : 'Device not found');
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(deviceId));
  }

  Future<void> setPower(bool value) async {
    final current = state.value;
    if (current == null || !current.isOnline) return;
    state = AsyncData(current.copyWith(isPowerOn: value));
    final result = await ref.read(deviceRepositoryProvider).updatePower(
          homeId: current.homeId,
          deviceId: current.id,
          isPowerOn: value,
        );
    if (result is Failure) {
      state = AsyncData(current);
      throw Exception(result.message);
    }
  }

  Future<void> setLightState(LightState value) async {
    final current = state.value;
    if (current == null || !current.isOnline) return;
    state = AsyncData(current.copyWith(lightState: value));
    final result = await ref.read(deviceRepositoryProvider).updateLightState(
          homeId: current.homeId,
          deviceId: current.id,
          brightness: value.brightness,
          colorTemperature: value.colorTemperature,
        );
    if (result is Failure) {
      state = AsyncData(current);
      throw Exception(result.message);
    }
  }

  Future<void> setAirConditionerState(AirConditionerState value) async {
    final current = state.value;
    if (current == null || !current.isOnline) return;
    state = AsyncData(current.copyWith(airConditionerState: value));
    final result =
        await ref.read(deviceRepositoryProvider).updateAirConditionerState(
              homeId: current.homeId,
              deviceId: current.id,
              targetTemperature: value.targetTemperature,
              mode: value.mode.name,
              fanSpeed: value.fanSpeed.name,
            );
    if (result is Failure) {
      state = AsyncData(current);
      throw Exception(result.message);
    }
  }
}
