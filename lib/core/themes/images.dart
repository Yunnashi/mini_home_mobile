import 'package:mini_home/environment/environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'images.g.dart';

@riverpod
AppImages appImages(Ref ref) {
  final appCode = ref.watch(appEnvironmentProvider).config.appCode;
  return AppImages(appCode: appCode);
}

class AppImages {
  final String brandingPath;
  final commonPath = "assets/common";

  // White Label別に掲載する画像が違う場合はすべてbrandingから取得
  AppImages({required String appCode})
      : brandingPath = "assets/branding/$appCode";

  String get splashBackground => "$brandingPath/images/background_splash.png";
  String get splash => "$brandingPath/images/splash.png";

  String get mainImage => "$brandingPath/images/main_image.png";

  String get deviceElla => "$brandingPath/images/device_ella.png";
  String get deviceIndustrial => "$brandingPath/images/device_industrial.png";
  String get deviceNadiya => "$brandingPath/images/device_nadiya.png";

  // 共通
  String get noDevice => "$commonPath/images/no_device.png";

  String get iconElla => "$commonPath/images/icon_ella.png";
  String get iconIndustrial => "$commonPath/images/icon_industrial.png";
  String get iconNadiya => "$commonPath/images/icon_nadiya.png";

  String get promotionBanner => "$commonPath/images/promotion_banner.png";
}
