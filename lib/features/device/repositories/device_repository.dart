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

  Future<Result> getDeviceById({
    required int userGroupId,
    required int deviceId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId',
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

  Future<Result> createDeviceToUserGroup({
    required int userGroupId,
    required String encryptedDeviceId,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.userGroups}/$userGroupId/devices',
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
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/charging-ampere',
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
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/nickname',
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
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/fw-update',
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
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/reboot-otp',
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
