import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/utils/loading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mini_home/features/device/repositories/device_repository.dart';

part 'device_service.g.dart';

@riverpod
class DeviceService extends _$DeviceService {
  Device? _device;

  @override
  Device? build() {
    return _device;
  }

  /// ホーム配下のデバイス詳細を取得
  Future<void> getDeviceById({
    required int homeId,
    required int deviceId,
    Function(Device)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      final deviceRepository = ref.read(deviceRepositoryProvider);
      final response = await deviceRepository.getDeviceById(
        homeId: homeId,
        deviceId: deviceId,
      );

      if (response is Success) {
        final device = Device.fromJson(response.value);
        _device = device;
        state = device;
        successCallback?.call(device);
      } else if (response is Failure) {
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      errorCallback?.call(e.toString(), 'HOME_DEVICE_DETAIL_ERROR');
    }
  }

  /// ホームにデバイスを追加
  Future<void> createDeviceToHome({
    required int homeId,
    required String encryptedDeviceId,
    Function(dynamic)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final deviceRepository = ref.read(deviceRepositoryProvider);
      final response = await deviceRepository.createDeviceToHome(
        homeId: homeId,
        encryptedDeviceId: encryptedDeviceId,
      );

      switch (response) {
        case Success(value: final data):
          Loading().dismiss();
          successCallback?.call(data);

        case Failure(message: final message, code: final code):
          Loading().dismiss();
          errorCallback?.call(message, code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'CREATE_DEVICE_TO_HOME_ERROR');
    }
  }

  /// デバイスのニックネームを更新
  Future<void> updateNickname({
    required int userGroupId,
    required int deviceId,
    required String nickname,
    Function(String?)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final deviceRepository = ref.read(deviceRepositoryProvider);
      final response = await deviceRepository.updateNickname(
        userGroupId: userGroupId,
        deviceId: deviceId,
        nickname: nickname,
      );
      if (response is Success) {
        final updatedDevice =
            Device.fromJson(response.value as Map<String, dynamic>);
        Loading().dismiss();
        successCallback?.call(updatedDevice.nickname);
      } else if (response is Failure) {
        Loading().dismiss();
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'UPDATE_NICKNAME_ERROR');
    }
  }

  /// デバイスのファームウェアをアップデートをリクエスト
  Future<void> requestFwUpdate({
    required int homeId,
    required int deviceId,
    Function()? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final deviceRepository = ref.read(deviceRepositoryProvider);
      final response = await deviceRepository.requestFwUpdate(
        homeId: homeId,
        deviceId: deviceId,
      );
      if (response is Success) {
        Loading().dismiss();
        successCallback?.call();
      } else if (response is Failure) {
        Loading().dismiss();
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'REQUEST_FW_UPDATE_ERROR');
    }
  }
}
