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

  // White Label別に掲載する画像が違う場合はすべてbrandingから取得
  AppImages({required String appCode})
      : brandingPath = "assets/branding/$appCode";

  String get splashBackground => "$brandingPath/images/background_splash.png";
  String get splash => "$brandingPath/images/splash.png";

  String get mainImage => "$brandingPath/images/main_image.png";
}
