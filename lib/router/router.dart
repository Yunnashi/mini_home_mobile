import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/features/web_view/models/web_view_args.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:mini_home/screens/account_settings/account_settings_screen.dart';
import 'package:mini_home/screens/device_detail/device_detail_screen.dart';
import 'package:mini_home/screens/device_detail/device_setting/device_setting_screen.dart';
import 'package:mini_home/screens/device_detail/usages/usages_screen.dart';
import 'package:mini_home/screens/home/home_screen.dart';
import 'package:mini_home/screens/device_registration/device_registration_screen.dart';
import 'package:mini_home/screens/password_change/password_change_screen.dart';
import 'package:mini_home/screens/password_reset/password_reset_screen.dart';
import 'package:mini_home/screens/schedule/schedule_create_screen.dart';
import 'package:mini_home/screens/schedule/schedule_edit_screen.dart';
import 'package:mini_home/screens/sign_in/sign_in_screen.dart';
import 'package:mini_home/screens/sign_up/sign_up_screen.dart';
import 'package:mini_home/screens/splash/splash_screen.dart';
import 'package:mini_home/screens/web_view/web_view_screen.dart';
import 'package:mini_home/screens/withdrawal/withdrawal_screen.dart';
import 'package:mini_home/router/app_route_observer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

class AppRoutes {
  static const String splash = 'splashScreen';
  static const String home = 'homeScreen';
  static const String signUp = 'signUpScreen';
  static const String signIn = 'signInScreen';
  static const String passwordReset = 'passwordResetScreen';
  static const String passwordChange = 'passwordChangeScreen';
  static const String webView = 'webViewScreen';
  static const String chargingHistory = 'chargingHistoryScreen';
  static const String accountSettings = 'accountSettingsScreen';
  static const String withdrawal = 'withdrawalScreen';
  static const String deviceRegistration = 'deviceRegistrationScreen';
  static const String deviceDetail = 'deviceDetailScreen';
  static const String deviceSetting = 'deviceSettingScreen';
  static const String scheduleCreate = 'scheduleCreateScreen';
  static const String scheduleEdit = 'scheduleEditScreen';
  static const String usages = 'usagesScreen';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(
      initialLocation: '/splash',
      observers: [
        ref.watch(routeObserverProvider),
      ],
      routes: [
        GoRoute(
          name: AppRoutes.splash,
          path: '/splash',
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/',
          name: AppRoutes.home,
          pageBuilder: (context, state) =>
              _buildPageWithAnimation(HomeScreen(key: homeScreenKey)),
        ),
        GoRoute(
          path: '/sign-up',
          name: AppRoutes.signUp,
          builder: (context, state) => SignUpScreen(),
        ),
        GoRoute(
          path: '/sign-in',
          name: AppRoutes.signIn,
          builder: (context, state) => SignInScreen(),
        ),
        GoRoute(
          path: '/password-reset',
          name: AppRoutes.passwordReset,
          builder: (context, state) => PasswordResetScreen(),
        ),
        GoRoute(
          path: '/password-change',
          name: AppRoutes.passwordChange,
          builder: (context, state) => PasswordChangeScreen(),
        ),
        GoRoute(
          path: '/web-view',
          name: AppRoutes.webView,
          builder: (context, state) {
            final args = state.extra as WebViewArgs;
            return WebViewScreen(args: args);
          },
        ),
        GoRoute(
          path: '/account-settings',
          name: AppRoutes.accountSettings,
          builder: (context, state) => AccountSettingsScreen(),
        ),
        GoRoute(
          path: '/withdrawal',
          name: AppRoutes.withdrawal,
          builder: (context, state) => WithdrawalScreen(),
        ),
        GoRoute(
          path: '/device-registration',
          name: AppRoutes.deviceRegistration,
          builder: (context, state) => DeviceRegistrationScreen(),
        ),
        GoRoute(
          path: '/device-detail/:deviceId',
          name: AppRoutes.deviceDetail,
          builder: (context, state) {
            final deviceId = int.parse(state.pathParameters['deviceId']!);
            return DeviceDetailScreen(deviceId: deviceId);
          },
          routes: [
            GoRoute(
              path: 'settings',
              name: AppRoutes.deviceSetting,
              builder: (context, state) {
                final deviceId = int.parse(state.pathParameters['deviceId']!);
                return DeviceSettingScreen(deviceId: deviceId);
              },
            ),
            GoRoute(
              path: 'usages',
              name: AppRoutes.usages,
              builder: (context, state) {
                final deviceId = int.parse(state.pathParameters['deviceId']!);
                return UsagesScreen(deviceId: deviceId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/schedule/create/:deviceId',
          name: AppRoutes.scheduleCreate,
          builder: (context, state) {
            final deviceId = int.parse(state.pathParameters['deviceId']!);
            return ScheduleCreateScreen(deviceId: deviceId);
          },
        ),
        GoRoute(
          path: '/schedule/edit/:deviceId',
          name: AppRoutes.scheduleEdit,
          builder: (context, state) {
            final deviceId = int.parse(state.pathParameters['deviceId']!);
            final schedule = state.extra as Schedule;
            return ScheduleEditScreen(schedule: schedule, deviceId: deviceId);
          },
        ),
        // 他の画面のルートもここに追加
      ],
    );

// 画面遷移のアニメーションを定義
// フェードイン×スケールアップ splashスクリーンからの遷移時に利用
CustomTransitionPage<void> _buildPageWithAnimation(Widget page) {
  return CustomTransitionPage<void>(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      );
    },
  );
}
