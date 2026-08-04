import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/device/models/air_conditioner_state.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/light_state.dart';
import 'package:mini_home/features/device/repositories/device_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'smart_device_service.g.dart';

@riverpod
class SmartDeviceService extends _$SmartDeviceService {
  @override
  Future<Device> build(int deviceId) async {
    final authState = await ref.watch(authStateServiceProvider.future);
    final homeId = authState.defaultHomeId;
    if (homeId == null) {
      throw Exception('Default home is not configured');
    }
    return _fetch(homeId: homeId, deviceId: deviceId);
  }

  Future<Device> _fetch({required int homeId, required int deviceId}) async {
    final result = await ref.read(deviceRepositoryProvider).getSmartDevice(
          homeId: homeId,
          deviceId: deviceId,
        );
    if (result case Success(value: final value)) {
      return Device.fromJson(value as Map<String, dynamic>);
    }
    throw Exception(result is Failure ? result.message : 'Device not found');
  }

  Future<void> refresh({bool showLoading = true}) async {
    final previous = state;
    if (showLoading) {
      state = const AsyncLoading();
    }
    final authState = await ref.read(authStateServiceProvider.future);
    final homeId = authState.defaultHomeId;
    final next = await AsyncValue.guard(() async {
      if (homeId == null) {
        throw Exception('Default home is not configured');
      }
      return _fetch(homeId: homeId, deviceId: deviceId);
    });
    if (!showLoading && next.hasError && previous.hasValue) {
      return;
    }
    state = next;
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

  Future<void> updateMetadata(
      {required String name, required int roomId}) async {
    final current = state.value;
    if (current == null) return;
    final result = await ref.read(deviceRepositoryProvider).updateMetadata(
          homeId: current.homeId,
          deviceId: current.id,
          name: name,
          roomId: roomId,
        );
    if (result is Failure) throw Exception(result.message);
    state =
        AsyncData(current.copyWith(name: name, nickname: name, roomId: roomId));
  }

  Future<void> deleteDevice() async {
    final current = state.value;
    if (current == null) return;
    final result = await ref.read(deviceRepositoryProvider).deleteSmartDevice(
          homeId: current.homeId,
          deviceId: current.id,
        );
    if (result is Failure) throw Exception(result.message);
  }
}
