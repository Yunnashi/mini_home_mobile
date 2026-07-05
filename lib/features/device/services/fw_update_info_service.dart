import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/environment/environment.dart';
import 'package:mini_home/features/device/models/fw_update_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fw_update_info_service.g.dart';

@riverpod
Future<FwUpdateInfoService> fwUpdateInfoService(Ref ref) async {
  final appEnvironment = ref.watch(appEnvironmentProvider);

  final service = FwUpdateInfoService(
    appEnvironment: appEnvironment,
    rc: appEnvironment.config.isFirebaseEnabled
        ? FirebaseRemoteConfig.instance
        : null,
  );

  await service.init();

  return service;
}

class FwUpdateInfoService {
  final FirebaseRemoteConfig? rc;
  final AppEnvironmentData appEnvironment;

  static const String _fwUpdateInfoKey = "fw_update_info";

  FwUpdateInfoService({
    required this.appEnvironment,
    required this.rc,
  });

  Future<void> init() async {
    final remoteConfig = rc;
    if (remoteConfig == null) return;

    final cacheInterval = appEnvironment.config.isProduct
        ? const Duration(hours: 1)
        : Duration.zero;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: cacheInterval,
      ),
    );
  }

  /// RemoteConfigからFwUpdateInfoを取得する
  Future<FwUpdateInfo?> fetchFwUpdateInfo() async {
    final remoteConfig = rc;
    if (remoteConfig == null) return null;

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      return null;
    }

    final fwUpdateInfoString = remoteConfig.getString(_fwUpdateInfoKey);
    if (fwUpdateInfoString.isEmpty) {
      return null;
    }

    final json = jsonDecode(fwUpdateInfoString) as Map<String, dynamic>;
    return FwUpdateInfo.fromJson(json);
  }
}
