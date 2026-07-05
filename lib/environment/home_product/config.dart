import 'package:mini_home/environment/app_config.dart';

class AppProductionConfig extends AppConfig {
  @override
  String get appCode => "mini_home";

  @override
  bool get isFirebaseEnabled => const bool.fromEnvironment("ENABLE_FIREBASE");

  @override
  String get apiScheme => const String.fromEnvironment(
        "API_SCHEME",
        defaultValue: "https",
      );

  @override
  String get apiHost => const String.fromEnvironment("API_HOST");

  @override
  bool get isProduct => true;

  @override
  RegExp get qrUrlRegExpSource => RegExp(
        const String.fromEnvironment(
          "DEVICE_QR_URL_PATTERN",
          defaultValue: r'^https:\/\/example\.com\/devices\/([a-zA-Z0-9_-]+)$',
        ),
      );

  @override
  String get appApiKey => const String.fromEnvironment("APP_API_KEY");

  @override
  String get playStoreLink => const String.fromEnvironment(
        "PLAY_STORE_URL",
        defaultValue: "https://play.google.com/store/apps",
      );

  @override
  String get appStoreLink => const String.fromEnvironment(
        "APP_STORE_URL",
        defaultValue: "https://apps.apple.com/",
      );

  @override
  String? get contactTel => null;
}
