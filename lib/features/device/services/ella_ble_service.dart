import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';

final ellaBleServiceProvider = Provider.autoDispose<EllaBleService>((ref) {
  final service = EllaBleService();
  ref.onDispose(() {
    unawaited(service.disconnect());
  });
  return service;
});

/// BLE 検索〜OTP 書き込みまでの失敗理由。呼び出し元でメッセージ表示に利用する。
enum EllaBleSearchFailureReason {
  permissionDenied,
  bluetoothOff,
  invalidDeviceId,
  deviceNotFound,
  challengeFailed,
  writeOtpFailed,
}

class EllaBleConfig {
  final String serviceUuidIOS;
  final String serviceUuidAndroid;
  final String serviceDataKey;
  final String challengeUuid;
  final String otpUuid;

  const EllaBleConfig({
    this.serviceUuidIOS = 'FD8B',
    this.serviceUuidAndroid = '0000FD8B-0000-1000-8000-00805F9B34FB',
    this.serviceDataKey = 'FD8B',
    this.challengeUuid = '5E52E613-07B3-E384-D247-BD2449C2B7D5',
    this.otpUuid = 'BE74312E-13FD-4008-9879-568F49A772D1',
  });
}

class EllaBleService {
  EllaBleService({EllaBleConfig config = const EllaBleConfig()})
      : _config = config;

  final EllaBleConfig _config;
  BluetoothDevice? _device;

  BluetoothDevice? get device => _device;

  Future<bool> search(
    BuildContext? context,
    String targetDeviceId,
  ) async {
    final normalizedDeviceId = _normalizeDeviceId(targetDeviceId);
    if (normalizedDeviceId.length < 6) {
      safeDebugPrint('[EllaBLE] targetDeviceId is too short: $targetDeviceId');
      _showBleError(context, EllaBleSearchFailureReason.invalidDeviceId);
      return false;
    }

    final hasPermission = await requestPermission();
    if (!hasPermission) {
      _showBluetoothPermissionDialog(context);
      return false;
    }

    final isBluetoothOn = await _ensureBluetoothOn();
    if (!isBluetoothOn) {
      _showBleError(context, EllaBleSearchFailureReason.bluetoothOff);
      return false;
    }

    // Android では常に true（Android 12+ でも manufacturer data・一部デバイス・古い端末では位置が必要なため）
    final androidUsesFineLocation = Platform.isAndroid;

    await _stopScanSafely();
    final completer = Completer<BluetoothDevice?>();
    var completed = false;

    late StreamSubscription<List<ScanResult>> subscription;
    if (Platform.isAndroid) {
      try {
        final services = [Guid(_config.serviceUuidAndroid)];
        await FlutterBluePlus.startScan(
          withServices: services,
          timeout: const Duration(seconds: 8),
          androidUsesFineLocation: androidUsesFineLocation,
        );
        subscription = FlutterBluePlus.scanResults.listen((results) {
          if (completed) return;
          safeDebugPrint('[EllaBLE] Android scanResults: ${results.length}');
          for (final result in results) {
            if (_isTargetDevice(result, normalizedDeviceId)) {
              completed = true;
              completer.complete(result.device);
              break;
            }
          }
        });
      } catch (e) {
        safeDebugPrint('[EllaBLE] Android startScan failed: $e');
        rethrow;
      }
    } else {
      subscription = FlutterBluePlus.onScanResults.listen((results) {
        if (completed) return;
        for (final result in results) {
          if (_isTargetDevice(result, normalizedDeviceId)) {
            completed = true;
            completer.complete(result.device);
            break;
          }
        }
      });
    }

    try {
      if (!Platform.isAndroid) {
        final services = [Guid(_config.serviceUuidIOS)];
        await FlutterBluePlus.startScan(
          withServices: services,
          timeout: const Duration(seconds: 8),
          androidUsesFineLocation: androidUsesFineLocation,
        );
      }
      final foundDevice = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
      if (foundDevice == null) {
        _showBleError(context, EllaBleSearchFailureReason.deviceNotFound);
        return false;
      }
      _device = foundDevice;
      return true;
    } catch (e) {
      safeDebugPrint('[EllaBLE] Search failed: $e');
      _showBleError(context, EllaBleSearchFailureReason.deviceNotFound);
      return false;
    } finally {
      completed = true;
      await subscription.cancel();
      await _stopScanSafely();
    }
  }

  void _showBleError(BuildContext? context, EllaBleSearchFailureReason reason) {
    if (context == null || !context.mounted) return;
    final message = switch (reason) {
      EllaBleSearchFailureReason.permissionDenied =>
        AppStrings.blePermissionDenied,
      EllaBleSearchFailureReason.bluetoothOff => AppStrings.bleBluetoothOff,
      EllaBleSearchFailureReason.invalidDeviceId =>
        AppStrings.bleInvalidDeviceId,
      EllaBleSearchFailureReason.deviceNotFound => AppStrings.bleSearchFailed,
      EllaBleSearchFailureReason.challengeFailed => AppStrings.bleSearchFailed,
      EllaBleSearchFailureReason.writeOtpFailed => AppStrings.bleSearchFailed,
    };
    BasicDialog.showError(
      context: context,
      customMessage: message,
      title: AppStrings.error,
    );
  }

  /// 権限拒否時のみ。muchapp-mobile select_item の挙動に合わせ「設定を開く」を案内するダイアログ。
  Future<void> _showBluetoothPermissionDialog(BuildContext? context) async {
    if (context == null || !context.mounted) return;
    await BasicDialog.show(
      context: context,
      title: AppStrings.permissionErrorTitle,
      content: Text(AppStrings.blePermissionDenied),
      barrierDismissible: true,
      buttons: [
        BasicDialogButton.cancel(text: AppStrings.close),
        BasicDialogButton.ok(
          text: AppStrings.settings,
          autoClose: false,
          callback: () async {
            await openAppSettings();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  /// virtual key hook.dart の getChallenge に合わせる: read 結果をそのまま base64 で返す（長さチェックなし）。
  Future<List<int>?> readChallengeBytes() async {
    try {
      final currentDevice = _device;
      if (currentDevice == null) {
        return null;
      }

      await _connectWithRetry(currentDevice, skipIfConnected: true);
      await Future.delayed(const Duration(milliseconds: 200));

      final characteristic = await _getCharacteristic(
        currentDevice,
        _config.challengeUuid,
      );
      if (characteristic == null) {
        return null;
      }

      final value =
          await characteristic.read().timeout(const Duration(seconds: 5));
      return value;
    } catch (e) {
      safeDebugPrint('[EllaBLE] Challenge read failed: $e');
      return null;
    }
  }

  Future<String?> readChallengeBase64(BuildContext? context) async {
    final challengeBytes = await readChallengeBytes();
    if (challengeBytes == null || challengeBytes.isEmpty) {
      _showBleError(context, EllaBleSearchFailureReason.challengeFailed);
      return null;
    }
    return base64.encode(challengeBytes);
  }

  Future<String?> getChallenge(BuildContext? context) {
    return readChallengeBase64(context);
  }

  Future<bool> writeOtpBase64(
    String otpBase64, {
    BuildContext? context,
  }) async {
    try {
      final otpBytes = base64.decode(otpBase64);
      return writeOtpBytes(otpBytes, context: context);
    } on FormatException catch (e) {
      safeDebugPrint('[EllaBLE] Invalid OTP base64: $e');
      _showBleError(context, EllaBleSearchFailureReason.writeOtpFailed);
      return false;
    }
  }

  Future<bool> writeOtpBytes(
    List<int> otpBytes, {
    BuildContext? context,
  }) async {
    try {
      final currentDevice = _device;
      if (currentDevice == null) {
        _showBleError(context, EllaBleSearchFailureReason.writeOtpFailed);
        return false;
      }

      await _connectWithRetry(currentDevice, skipIfConnected: true);

      final characteristic = await _getCharacteristic(
        currentDevice,
        _config.otpUuid,
      );
      if (characteristic == null) {
        _showBleError(context, EllaBleSearchFailureReason.writeOtpFailed);
        return false;
      }

      await characteristic.write(
        otpBytes,
        allowLongWrite: true,
      );
      return true;
    } catch (e) {
      safeDebugPrint('[EllaBLE] OTP write failed: $e');
      // 送信直後にデバイスが再起動して切断されると例外になることがある。送信は成功している可能性が高いためエラーは出さず成功扱いにする。
      return true;
    }
  }

  Future<bool> writeOtp(String otpBase64, {BuildContext? context}) {
    return writeOtpBase64(otpBase64, context: context);
  }

  Future<void> disconnect() async {
    final currentDevice = _device;
    _device = null;

    if (currentDevice == null) {
      return;
    }

    try {
      await currentDevice.disconnect();
    } catch (e) {
      safeDebugPrint('[EllaBLE] Disconnect failed: $e');
    }
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final permissions = <Permission>[
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ];

      await permissions.request();
      final scanGranted =
          await Permission.bluetoothScan.status == PermissionStatus.granted;
      final connectGranted =
          await Permission.bluetoothConnect.status == PermissionStatus.granted;
      final locationGranted =
          await Permission.locationWhenInUse.status == PermissionStatus.granted;
      return scanGranted && connectGranted && locationGranted;
    }

    if (Platform.isIOS) {
      final status = await [Permission.bluetooth].request();
      return status[Permission.bluetooth] == PermissionStatus.granted;
    }

    return false;
  }

  /// hex の先頭2文字(partnerId) + 末尾4文字(deviceId) → "EL"+大文字。
  /// 4バイト以上なら type(2-4文字目)== "03" のときだけ対象（isValidEllaDevice）。
  bool _isTargetDevice(ScanResult result, String normalizedDeviceId) {
    final serviceData = result.advertisementData.serviceData;
    final data = _getFd8bServiceData(serviceData);
    if (data == null || data.length < 3) {
      return false;
    }
    final hex = _bytesToHex(data);
    if (data.length >= 4) {
      final deviceType = hex.substring(2, 4);
      if (deviceType != '03') return false;
    }
    final advPartnerId = hex.substring(0, 2);
    final advDeviceId = hex.substring(hex.length - 4);
    final scannedDeviceId =
        'EL${advPartnerId.toUpperCase()}${advDeviceId.toUpperCase()}';
    return normalizedDeviceId == scannedDeviceId;
  }

  /// FD8B の serviceData を取得。Android で Guid 表記ゆれがある場合に備えキーを複数試す。
  /// PIYOCHARGE ble_utils は 0000fd8b-0000-1000-8000-00805f9b34fb で lookup しているため、フル UUID も試す。
  List<int>? _getFd8bServiceData(Map<Guid, List<int>> serviceData) {
    final shortGuid = Guid(_config.serviceDataKey);
    if (serviceData.containsKey(shortGuid)) {
      return serviceData[shortGuid];
    }
    final fullUuid = '0000fd8b-0000-1000-8000-00805f9b34fb';
    final fullGuid = Guid(fullUuid);
    if (serviceData.containsKey(fullGuid)) {
      return serviceData[fullGuid];
    }
    if (!Platform.isAndroid) return null;
    for (final entry in serviceData.entries) {
      if (entry.key.toString().toLowerCase().contains('fd8b')) {
        return entry.value;
      }
    }
    return null;
  }

  String _bytesToHex(List<int> data) {
    return data
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }

  /// 区切り文字（スペース・ハイフンなど）のみ除去し大文字に。接頭辞 "EL" などは残す。
  String _normalizeDeviceId(String deviceId) {
    return deviceId.replaceAll(RegExp(r'[\s\-_:.]'), '').toUpperCase();
  }

  Future<bool> _ensureBluetoothOn() async {
    var adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState == BluetoothAdapterState.on) {
      return true;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState == BluetoothAdapterState.on) {
      return true;
    }

    if (Platform.isAndroid && adapterState == BluetoothAdapterState.off) {
      try {
        await FlutterBluePlus.turnOn();
        await Future.delayed(const Duration(milliseconds: 500));
        adapterState = await FlutterBluePlus.adapterState.first;
      } catch (e) {
        safeDebugPrint('[EllaBLE] turnOn failed: $e');
      }
    }

    return adapterState == BluetoothAdapterState.on;
  }

  Future<void> _stopScanSafely() async {
    try {
      await FlutterBluePlus.stopScan();
      await Future.delayed(Duration(
        milliseconds: Platform.isAndroid ? 1000 : 400,
      ));
    } catch (e) {
      safeDebugPrint('[EllaBLE] stopScan failed (ignored): $e');
      await Future.delayed(Duration(
        milliseconds: Platform.isAndroid ? 500 : 200,
      ));
    }
  }

  Future<void> _connectWithRetry(
    BluetoothDevice device, {
    bool skipIfConnected = false,
  }) async {
    if (skipIfConnected && device.isConnected) {
      return;
    }

    var retryCount = 0;
    const maxRetries = 3;
    var wasAlreadyConnected = false;

    while (retryCount < maxRetries) {
      try {
        await device.connect().timeout(const Duration(seconds: 5));
        break;
      } on FlutterBluePlusException catch (e) {
        retryCount++;
        if (e.code == 62) {
          wasAlreadyConnected = true;
          break;
        }

        if (retryCount >= maxRetries) {
          rethrow;
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    await Future.delayed(
      Duration(milliseconds: wasAlreadyConnected ? 100 : 300),
    );
  }

  /// virtual key util.dart の getCharacteristic と同じ構成。UUID は toUpperCase で比較し、
  /// プラットフォーム差でハイフン有無が変わる場合に備え _normalizeUuid で正規化する。
  Future<BluetoothCharacteristic?> _getCharacteristic(
    BluetoothDevice device,
    String targetUuid,
  ) async {
    List<BluetoothService> services;
    try {
      services = await device.discoverServices();
    } catch (_) {
      services = device.servicesList;
    }

    final normalizedTarget = _normalizeUuid(targetUuid);
    for (final service in services) {
      for (final c in service.characteristics) {
        if (_normalizeUuid(c.uuid.toString()) == normalizedTarget) {
          return c;
        }
      }
    }
    return null;
  }

  /// UUID 比較用: ハイフン除去・大文字化（virtual key は toUpperCase のみ。こちらは表記ゆれ対策で正規化）
  static String _normalizeUuid(String uuid) {
    return uuid.replaceAll(RegExp(r'[\-]'), '').toUpperCase();
  }
}
