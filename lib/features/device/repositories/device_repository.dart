import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/core/constants/api_endpoints.dart';
import 'package:mini_home/core/network/dio_client.dart';
import 'package:mini_home/core/network/models/api_request_base.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_repository.g.dart';

@riverpod
DeviceRepository deviceRepository(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DeviceRepository._(dioClient);
}

class DeviceRepository {
  final DioClient _dioClient;

  DeviceRepository._(this._dioClient);

  Future<Result> getDevices({required int homeId}) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.devices(homeId),
      method: HttpMethod.get,
      isLoggedInContent: true,
      successCallback: (data) => response = Success(data),
      errorCallback: (message, code) => response = Failure(message, code: code),
    );
    return response ?? Failure('Unable to load devices');
  }

  Future<Result> updatePower({
    required int homeId,
    required int deviceId,
    required bool isPowerOn,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.device(homeId, deviceId),
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {'isPowerOn': isPowerOn},
      successCallback: (data) => response = Success(data),
      errorCallback: (message, code) => response = Failure(message, code: code),
    );
    return response ?? Failure('Unable to update device');
  }

  Future<Result> getSmartDevice({
    required int homeId,
    required int deviceId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.device(homeId, deviceId),
      method: HttpMethod.get,
      isLoggedInContent: true,
      successCallback: (data) => response = Success(data),
      errorCallback: (message, code) => response = Failure(message, code: code),
    );
    return response ?? Failure('Unable to load device');
  }

  Future<Result> updateLightState({
    required int homeId,
    required int deviceId,
    required int brightness,
    required int colorTemperature,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.device(homeId, deviceId)}/light-state',
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {
        'brightness': brightness,
        'colorTemperature': colorTemperature,
      },
      successCallback: (data) => response = Success(data),
      errorCallback: (message, code) => response = Failure(message, code: code),
    );
    return response ?? Failure('Unable to update light');
  }

  Future<Result> updateAirConditionerState({
    required int homeId,
    required int deviceId,
    required int targetTemperature,
    required String mode,
    required String fanSpeed,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath:
          '${ApiEndpoints.device(homeId, deviceId)}/air-conditioner-state',
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {
        'targetTemperature': targetTemperature,
        'mode': mode,
        'fanSpeed': fanSpeed,
      },
      successCallback: (data) => response = Success(data),
      errorCallback: (message, code) => response = Failure(message, code: code),
    );
    return response ?? Failure('Unable to update air conditioner');
  }

  Future<Result> updateMetadata({
    required int homeId,
    required int deviceId,
    required String name,
    required int roomId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.device(homeId, deviceId),
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {'name': name, 'roomId': roomId},
      successCallback: (data) => response = Success(data),
      errorCallback: (message, code) => response = Failure(message, code: code),
    );
    return response ?? Failure('Unable to update device');
  }

  Future<Result> deleteSmartDevice({
    required int homeId,
    required int deviceId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.device(homeId, deviceId),
      method: HttpMethod.delete,
      isLoggedInContent: true,
      successCallback: (data) => response = Success(data),
      errorCallback: (message, code) => response = Failure(message, code: code),
    );
    return response ?? Failure('Unable to delete device');
  }

  Future<Result> getDeviceById({
    required int userGroupId,
    required int deviceId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.device(userGroupId, deviceId),
      method: HttpMethod.get,
      isLoggedInContent: true,
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> createDeviceToHome({
    required int homeId,
    required String encryptedDeviceId,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.devices(homeId)}/scan',
      method: HttpMethod.post,
      isLoggedInContent: true,
      body: {
        'encryptedDeviceId': encryptedDeviceId,
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );

    return response ?? Failure('Unknown error');
  }

  Future<Result> updateChargingAmpere({
    required int userGroupId,
    required int deviceId,
    required double chargingAmpere,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath:
          '${ApiEndpoints.device(userGroupId, deviceId)}/charging-ampere',
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {'chargingAmpere': chargingAmpere},
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> updateNickname({
    required int userGroupId,
    required int deviceId,
    required String nickname,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.device(userGroupId, deviceId)}/nickname',
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {'nickname': nickname},
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> requestFwUpdate({
    required int userGroupId,
    required int deviceId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.device(userGroupId, deviceId)}/fw-update',
      method: HttpMethod.patch,
      isLoggedInContent: true,
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> fetchRebootOtp({
    required int userGroupId,
    required int deviceId,
    required String deviceChallenge,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.device(userGroupId, deviceId)}/reboot-otp',
      method: HttpMethod.post,
      isLoggedInContent: true,
      body: {'deviceChallenge': deviceChallenge},
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }
}
