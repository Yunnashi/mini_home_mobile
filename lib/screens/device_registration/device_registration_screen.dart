import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/constants/api_errors.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/environment/environment.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/features/auth/services/auth_service.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/device/services/device_service.dart';
import 'package:mini_home/utils/string_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mini_home/utils/permission_service.dart';

class DeviceRegistrationScreen extends HookConsumerWidget {
  const DeviceRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = GoRouterState.of(context);
    final authState = state.extra as AuthState;
    final controller = useMemoized(() => MobileScannerController());
    final isFlashOn = useState(false);
    final hasCameraPermission = useState(false);
    final isProcessing = useState(false);
    final lifecycle = useAppLifecycleState();

    void onBackWhenScannedDeviceId(BuildContext context) {
      context.pop();
    }

    void onBack(BuildContext context) async {
      await controller.stop();
      context.pop();
    }

    Future<void> toggleTorch() async {
      isFlashOn.value = !isFlashOn.value;
      await controller.toggleTorch();
    }

    void showPermissionDialog() {
      if (hasCameraPermission.value || isProcessing.value) return;

      isProcessing.value = true;
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        BasicDialog.show(
          context: context,
          title: AppStrings.permissionErrorTitle,
          content: Text(AppStrings.cameraPermissionMessage),
          barrierDismissible: false,
          buttons: [
            BasicDialogButton.ok(
              text: AppStrings.settings,
              autoClose: false,
              callback: () async {
                await openAppSettings();
                isProcessing.value = false;
                context.pop();
              },
            ),
          ],
        );
      }
    }

    void showResendConfirmationEmailDialog(String? message, String? errorCode) {
      BasicDialog.showError(
        context: context,
        title: AppStrings.error,
        errorMessage: message,
        errorCode: errorCode,
        barrierDismissible: false,
        retryButtonText: AppStrings.resendConfirmationEmailButton,
        retryAction: () {
          ref.read(authServiceProvider.notifier).resendConfirmationEmail(
            successCallback: () {
              BasicToast.showToast(
                AppStrings.titleDialogRegisterSuccess,
                ToastType.success,
                toastLength: Toast.LENGTH_LONG,
              );
              context.pop();
            },
            errorCallback: (message, code) {
              BasicDialog.show(
                context: context,
                title: AppStrings.error,
                content: Text(message ?? AppStrings.deviceIdError),
                barrierDismissible: false,
                buttons: [
                  BasicDialogButton.ok(
                    callback: () {
                      context.pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        dismissAction: () {
          context.pop();
        },
      );
    }

    Future<void> stopCamera() async {
      await controller.stop();
    }

    Future<void> checkCameraPermission() async {
      if (isProcessing.value) return;

      final permission = ref.read(permissionServiceProvider);
      var cameraStatus = permission.value;
      if (cameraStatus != PermissionStatus.granted) {
        // パーミッションが許可されていない場合、リクエスト
        cameraStatus = await ref
            .read(permissionServiceProvider.notifier)
            .requestCameraPermission();
        if (cameraStatus != PermissionStatus.granted) {
          hasCameraPermission.value = false;
          // 許可されなかった場合、ダイアログを表示
          showPermissionDialog();
          return;
        }
      }

      if (cameraStatus == PermissionStatus.granted) {
        hasCameraPermission.value = true;
      }
    }

    // QRコード検出後のデバイス登録処理
    Future<void> handleDeviceIdScan({
      required String encryptedDeviceId,
      required VoidCallback onSuccess,
      required ValueNotifier<bool> isProcessing,
    }) async {
      final homeId = authState.defaultHomeId;
      if (homeId == null) {
        BasicDialog.show(
          context: context,
          title: AppStrings.error,
          content: Text(AppStrings.deviceIdError),
          barrierDismissible: false,
          buttons: [
            BasicDialogButton.ok(
              callback: () {
                context.pop();
              },
            ),
          ],
        );
        return;
      }
      isProcessing.value = true;
      await ref.read(deviceServiceProvider.notifier).createDeviceToHome(
            homeId: homeId,
            encryptedDeviceId: encryptedDeviceId,
            successCallback: (data) {
              onSuccess();
            },
            errorCallback: (message, code) {
              if (code == ApiErrors.email_unconfirmed.errorCode) {
                // メールアドレス未確認エラーの場合、確認メール再送ダイアログを表示
                showResendConfirmationEmailDialog(message, code);
                return;
              }
              BasicDialog.show(
                context: context,
                title: AppStrings.error,
                content: Text(message ?? AppStrings.deviceIdError),
                barrierDismissible: false,
                buttons: [
                  BasicDialogButton.ok(
                    callback: () {
                      context.pop();
                    },
                  ),
                ],
              );
            },
          );
    }

    useEffect(() {
      if (kDebugMode) {
        const encryptedDeviceId = String.fromEnvironment(
            'SPECIFIC_ENCRYPTED_DEVICE_ID',
            defaultValue: '');
        // NOTE: Debug時、コマンドによる暗号化DeviceID指定がある場合に限りそのDeviceを認識させる。
        if (!encryptedDeviceId.isNullOrEmpty) {
          handleDeviceIdScan(
            encryptedDeviceId: encryptedDeviceId,
            onSuccess: () => onBackWhenScannedDeviceId(context),
            isProcessing: isProcessing,
          );
          return;
        }
      }
      Future.microtask(() async {
        if (lifecycle == AppLifecycleState.resumed) {
          // 初回とフォアグラウンド復帰時
          await checkCameraPermission();
        } else if (lifecycle == AppLifecycleState.paused) {
          // バックグラウンド移行時
          await stopCamera();
        }
      });
      return null;
    }, [lifecycle]);

    final backgroundColor = AppColors.black.withOpacity(0.69);
    final env = ref.watch(appEnvironmentProvider);
    final qrUrlRegExpSource = env.config.qrUrlRegExpSource;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasicScreen(
        appBar: BasicAppBar.buildPushStyle(
          context: context,
          titleAppBar: AppStrings.readQr,
          onBackPressed: () => onBack(context),
          backgroundColor: AppColors.black,
        ),
        backgroundColor: AppColors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // パーミッションが許可されている場合、カメラビューを表示
                if (hasCameraPermission.value) ...[
                  MobileScanner(
                    controller: controller,
                    onDetect: (scannedData) async {
                      if (isProcessing.value) {
                        return;
                      }
                      String? value = scannedData.barcodes.first.displayValue;

                      if (value != null && qrUrlRegExpSource.hasMatch(value)) {
                        final match = qrUrlRegExpSource.firstMatch(value);
                        final extractedValue = match?.group(1);
                        if (extractedValue != null) {
                          await handleDeviceIdScan(
                            encryptedDeviceId: extractedValue,
                            onSuccess: () => onBackWhenScannedDeviceId(context),
                            isProcessing: isProcessing,
                          );
                          return;
                        }
                      }
                      isProcessing.value = true;
                      BasicDialog.show(
                        context: context,
                        title: AppStrings.error,
                        content: Text(AppStrings.deviceIdError),
                        barrierDismissible: false,
                        buttons: [
                          BasicDialogButton.ok(
                            callback: () {
                              isProcessing.value = false;
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  // 中央のくり抜き(透明)
                  ClipPath(
                    clipper: QRCodeOverlayClipper(),
                    child: Container(
                      color: backgroundColor,
                    ),
                  ),
                ] else
                  Container(
                      color: AppColors.black,
                      child: const Center(child: CircularProgressIndicator())),
                Positioned(
                  top: constraints.maxHeight / 2 + 120,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      AppStrings.readQrDescription,
                      style: AppTextStyle.body1TextWhite,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight / 2 + 240,
                  right: 32,
                  child: ElevatedButton.icon(
                    onPressed: hasCameraPermission.value
                        ? () async {
                            await toggleTorch();
                          }
                        : null,
                    icon: Icon(
                      isFlashOn.value
                          ? Icons.flashlight_off_outlined
                          : Icons.flashlight_on_outlined,
                      color: isFlashOn.value
                          ? AppColors.whiteText
                          : AppColors.text,
                      size: 30.0,
                    ),
                    label: Text(
                      AppStrings.flashSwitch(isFlashOn.value ? "off" : "on"),
                      style: isFlashOn.value
                          ? AppTextStyle.body4TextWhite.copyWith(height: 1.3)
                          : AppTextStyle.body4.copyWith(height: 1.3),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFlashOn.value ? AppColors.primary : AppColors.white,
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// くり抜き用のカスタムクリッパー
class QRCodeOverlayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    const cutoutSize = 240.0;
    final cutoutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutoutSize,
      height: cutoutSize,
    );

    return Path.combine(
        PathOperation.difference,
        path,
        Path()
          ..addRRect(
              RRect.fromRectAndRadius(cutoutRect, const Radius.circular(8))));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
