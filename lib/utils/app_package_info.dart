import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_package_info.g.dart';

@Riverpod(keepAlive: true)
Future<AppPackageInfo> packageInfo(Ref ref) async {
  final platformInfo = await PackageInfo.fromPlatform();
  return AppPackageInfo(platformInfo);
}

class AppPackageInfo {
  final PackageInfo platformInfo;
  AppPackageInfo(this.platformInfo);

  String generateVersionString() {
    if (kDebugMode) {
      return "${platformInfo.version}(${platformInfo.buildNumber})";
    }
    return platformInfo.version;
  }

  String appName() => platformInfo.appName;
}
