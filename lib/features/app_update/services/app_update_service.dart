import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/environment/environment.dart';
import 'package:mini_home/features/app_update/models/update_info.dart';
import 'package:mini_home/features/app_update/models/update_request_type.dart';
import 'package:mini_home/features/app_update/repositories/update_info_storage_repository.dart';
import 'package:mini_home/utils/app_package_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:version/version.dart';

part 'app_update_service.g.dart';

@riverpod
Future<AppUpdateCheckService> appUpdateCheckService(Ref ref) async {
  final packageInfo = await ref.watch(packageInfoProvider.future);
  final appEnvironment = ref.watch(appEnvironmentProvider);

  final service = AppUpdateCheckService(
    packageInfo: packageInfo,
    appEnvironment: appEnvironment,
    rc: appEnvironment.config.isFirebaseEnabled
        ? FirebaseRemoteConfig.instance
        : null,
  );

  await service.init();

  return service;
}

class AppUpdateCheckService {
  final FirebaseRemoteConfig? rc;
  final AppPackageInfo packageInfo;
  final AppEnvironmentData appEnvironment;
  final UpdateInfoStorageRepository _updateInfoStorageRepository =
      UpdateInfoStorageRepository();

  static const String _updateInfoKey = "update_info";

  AppUpdateCheckService({
    required this.packageInfo,
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

  /// RemoteConfigからUpdateInfoを取得し、
  /// バージョン比較とキャンセル日時比較からアップデート種別を返す
  Future<UpdateRequestType> fetchAndActivate() async {
    final remoteConfig = rc;
    if (remoteConfig == null) return UpdateRequestType.not;

    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {
      return UpdateRequestType.not;
    }

    final updateInfoString = remoteConfig.getString(_updateInfoKey);
    if (updateInfoString.isEmpty) {
      return UpdateRequestType.not;
    }

    final json = jsonDecode(updateInfoString) as Map<String, dynamic>;
    final updateInfo = UpdateInfo.fromJson(json);

    final currentAppVersion = Version.parse(packageInfo.platformInfo.version);
    final latestVersion = Version.parse(updateInfo.latestVersion!);
    final requiredVersion = Version.parse(updateInfo.requiredVersion!);
    final enabledAt = DateTime.parse(updateInfo.enabledAt!);

    final cancelledUpdateDateTimeString =
        await _updateInfoStorageRepository.loadLatestCancelVersionUpdateTime();
    final cancelledUpdateDateTime = cancelledUpdateDateTimeString != null
        ? DateTime.tryParse(cancelledUpdateDateTimeString)
        : null;

    final hasNewVersion = latestVersion > currentAppVersion ||
        requiredVersion > currentAppVersion;

    final isEnabled = enabledAt.isBefore(DateTime.now()) &&
        (cancelledUpdateDateTime == null ||
            enabledAt.isAfter(cancelledUpdateDateTime));

    if (!isEnabled || !hasNewVersion) {
      return UpdateRequestType.not;
    }

    return latestVersion > currentAppVersion &&
            requiredVersion <= currentAppVersion
        ? UpdateRequestType.cancelable
        : UpdateRequestType.forcibly;
  }
}
