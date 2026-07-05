import 'package:mini_home/environment/home_product/config.dart';

class AppStagingConfig extends AppProductionConfig {
  @override
  String get apiScheme => const String.fromEnvironment(
        "API_SCHEME",
        defaultValue: "http",
      );

  @override
  String get apiHost => const String.fromEnvironment(
        "API_HOST",
        defaultValue: "localhost:3001",
      );

  @override
  bool get isProduct => false;
}
