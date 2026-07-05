import 'package:mini_home/environment/home_product/firebase_environment.dart';
import 'package:mini_home/environment/home_staging/firebase_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/environment/app_config.dart';
import 'package:mini_home/environment/home_product/config.dart';
import 'package:mini_home/environment/home_staging/config.dart';
import 'package:mini_home/environment/firebase_environment.dart';

part 'environment.g.dart';

class AppEnvironmentData {
  final AppENV environment;
  final AppConfig config;
  final FirebaseEnvironment firebase;
  AppEnvironmentData(
      {required this.environment,
      required this.config,
      required this.firebase});
}

@Riverpod(keepAlive: true)
AppEnvironmentData appEnvironment(Ref ref) {
  const envArg = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  final environment = AppENVInit.fromString(envArg);
  late final AppConfig config;
  late final FirebaseEnvironment firebase;
  switch (environment) {
    case AppENV.homeProduct:
      config = AppProductionConfig();
      firebase = FirebaseEnvironmentProduct.makeEnvironment();
      break;
    case AppENV.homeStaging:
      config = AppStagingConfig();
      firebase = FirebaseEnvironmentStaging.makeEnvironment();
      break;
    default:
      config = AppStagingConfig();
      firebase = FirebaseEnvironmentStaging.makeEnvironment();
      break;
  }
  return AppEnvironmentData(
      environment: environment, config: config, firebase: firebase);
}

enum AppENV { homeProduct, homeStaging, notDefine }

extension AppENVInit on AppENV {
  static AppENV fromString(String arg) {
    switch (arg.toLowerCase()) {
      case "homeproduct":
        return AppENV.homeProduct;
      case "homestaging":
        return AppENV.homeStaging;
      default:
        return AppENV.notDefine;
    }
  }
}
