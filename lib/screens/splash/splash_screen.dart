import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/images.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/environment/environment.dart';
import 'package:mini_home/features/app_update/models/update_request_type.dart';
import 'package:mini_home/features/app_update/repositories/update_info_storage_repository.dart';
import 'package:mini_home/features/app_update/services/app_update_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  void _navigatorToHome(BuildContext context) {
    context.goNamed(AppRoutes.home);
  }

  Future<void> _navigatorToStore(WidgetRef ref) async {
    final environment = ref.read(appEnvironmentProvider).config;
    final targetUrl = Platform.isAndroid
        ? environment.playStoreLink
        : environment.appStoreLink;
    if (await canLaunchUrl(Uri.parse(targetUrl))) {
      await launchUrl(Uri.parse(targetUrl));
    } else {
      safeDebugPrint("エラー");
    }
  }

  void _showForceUpdateDialog(BuildContext context, WidgetRef ref) {
    BasicDialog.show(
      context: context,
      title: AppStrings.updateDialogTitle,
      content: Text(AppStrings.updateDialogMessage),
      barrierDismissible: false,
      buttons: [
        BasicDialogButton.ok(
          text: AppStrings.update,
          callback: () {
            _navigatorToStore(ref);
          },
        )
      ],
    );
  }

  void _showCancelableUpdateDialog(BuildContext context, WidgetRef ref) {
    BasicDialog.show(
      context: context,
      title: AppStrings.updateDialogTitle,
      content: Text(AppStrings.updateDialogMessage),
      barrierDismissible: false,
      buttons: [
        BasicDialogButton.ok(
          text: AppStrings.update,
          callback: () {
            _navigatorToStore(ref);
          },
        ),
        BasicDialogButton.cancel(
          text: AppStrings.passUpdate,
          callback: () async {
            final repository = UpdateInfoStorageRepository();
            await repository.setLatestCancelVersionUpdateTime(
              DateTime.now().toIso8601String(),
            );
            _navigatorToHome(context);
          },
        ),
      ],
    );
  }

  void _checkUpdateInfo({
    required BuildContext context,
    required WidgetRef ref,
    required UpdateRequestType updateRequestType,
  }) {
    switch (updateRequestType) {
      case UpdateRequestType.forcibly:
        _showForceUpdateDialog(context, ref);
        break;
      case UpdateRequestType.cancelable:
        _showCancelableUpdateDialog(context, ref);
        break;
      case UpdateRequestType.not:
        _navigatorToHome(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUpdateCheckServiceAsync = ref.watch(appUpdateCheckServiceProvider);
    final images = ref.watch(appImagesProvider);

    useEffect(() {
      if (!appUpdateCheckServiceAsync.hasValue) return null;

      Future.microtask(() async {
        final service = appUpdateCheckServiceAsync.value!;
        final updateRequestType = await service.fetchAndActivate();

        if (!context.mounted) return;

        _checkUpdateInfo(
          context: context,
          ref: ref,
          updateRequestType: updateRequestType,
        );
      });

      return null;
    }, [appUpdateCheckServiceAsync]);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(images.splashBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Image.asset(
                images.splash,
                width: 287,
                height: 271,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
