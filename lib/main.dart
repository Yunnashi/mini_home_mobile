import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/environment/environment.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/core/themes/app_themes.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  await _initProcess();

  final scope = EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ja')],
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('en'),
    useOnlyLangCode: true,
    saveLocale: false,
    path: 'assets/translations',
    child: const MiniHomeApp(),
  );

  runApp(ProviderScope(child: scope));
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.red
    ..backgroundColor = AppColors.white
    ..indicatorColor = AppColors.text
    ..textColor = AppColors.text
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.custom
    ..dismissOnTap = false;
}

Future<void> _initProcess() async {
  final container = ProviderContainer();
  final environment = container.read(appEnvironmentProvider);

  safeDebugPrint("-------InitEnvironment-------");
  safeDebugPrint("ENVIRONMENT: ${environment.environment}");
  safeDebugPrint("APP_CONFIG: ${environment.config.runtimeType}");
  safeDebugPrint("-----------------------------");

  if (environment.config.isFirebaseEnabled) {
    await Firebase.initializeApp(options: environment.firebase.options());
  }

  configLoading();
}

class MiniHomeApp extends ConsumerWidget {
  const MiniHomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'miniHome',
      theme: AppTheme.lightTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: ref.watch(appRouterProvider),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
