import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/fw_update_status.dart';
import 'package:mini_home/features/device/repositories/fw_update_requested_at_storage_repository.dart';
import 'package:mini_home/features/device/services/device_service.dart';
import 'package:mini_home/features/device/services/fw_update_pending_service.dart';
import 'package:mini_home/core/themes/strings.dart';

// ---- FW Update Progress Common Settings/Helpers ----
const Duration _kProgressInterval = Duration(seconds: 4); // 4秒ごと
const double _kProgressStep = 0.01; // 1%
const double _kProgressMax = 0.95; // 95%で停止

double _computeInitialProgress(DateTime startedAt) {
  final elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;
  final stepPerMs = _kProgressStep / _kProgressInterval.inMilliseconds;
  final initial = (elapsedMs * stepPerMs).clamp(0.0, _kProgressMax);
  return initial.toDouble();
}

Timer _startProgressTimer({
  required ValueNotifier<double> progress,
  required bool Function() isActive,
}) {
  return Timer.periodic(_kProgressInterval, (timer) {
    if (!isActive()) return;
    if (progress.value < _kProgressMax) {
      progress.value =
          (progress.value + _kProgressStep).clamp(0.0, _kProgressMax);
    } else {
      timer.cancel();
    }
  });
}

class FirmwareUpdateWidget extends HookConsumerWidget {
  final int? homeId;
  final ValueNotifier<Device?> device;
  final String? latestFwVersion;
  final bool isBanner;

  const FirmwareUpdateWidget({
    super.key,
    required this.device,
    this.homeId,
    required this.latestFwVersion,
    required this.isBanner,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fwUpdateRequestedAt = useState<int?>(null);

    // deviceが更新されたときにpending状態をチェック（ValueNotifierをlisten）
    useEffect(() {
      void checkPending(Device? currentDevice) {
        if (currentDevice == null || latestFwVersion == null) {
          fwUpdateRequestedAt.value = null;
          return;
        }

        Future.microtask(() async {
          // checkAndUpdateFwPendingにすべてを委譲
          final result = await checkAndUpdateFwPending(
            device: currentDevice,
            latestFwVersion: latestFwVersion!,
          );

          switch (result.status) {
            case FwPendingCheckStatus.none:
              fwUpdateRequestedAt.value = null;
              break;
            case FwPendingCheckStatus.pending:
              // result.requestedAtをそのまま使用（重複取得を避ける）
              fwUpdateRequestedAt.value = result.requestedAt;
              break;
            case FwPendingCheckStatus.completed:
              fwUpdateRequestedAt.value = null;
              // トースト表示（ダイアログ表示の有無に関わらず）
              BasicToast.showToast(
                  AppStrings.fwUpdateSuccess, ToastType.success,
                  toastLength: Toast.LENGTH_LONG);
              break;
            case FwPendingCheckStatus.timeout:
              fwUpdateRequestedAt.value = null;
              // トースト表示（ダイアログ表示の有無に関わらず）
              BasicToast.showToast(AppStrings.fwUpdateTimeout, ToastType.error,
                  toastLength: Toast.LENGTH_LONG);
              break;
          }
        });
      }

      // 初回チェック
      checkPending(device.value);

      // 変更を監視（ValueNotifierのaddListenerは引数なしのコールバック）
      void listener() => checkPending(device.value);
      device.addListener(listener);

      // タイムアウト検知のため、定期的にチェック（device更新が止まっても検知できるように）
      final timeoutTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        checkPending(device.value);
      });

      return () {
        device.removeListener(listener);
        timeoutTimer.cancel();
      };
    }, [device, latestFwVersion]);

    // ValueNotifierの変更を確実に検知するため、ValueListenableBuilderでラップ
    return ValueListenableBuilder<Device?>(
      valueListenable: device,
      builder: (context, currentDevice, _) {
        if (currentDevice == null) {
          return const SizedBox.shrink();
        }
        // latest 未取得時はバナーでは何も出さず、設定用ではデバイスバージョンだけ表示（空欄にしない）
        if (latestFwVersion == null) {
          if (isBanner) return const SizedBox.shrink();
          return _buildText(
            context: context,
            ref: ref,
            device: currentDevice,
            latestFwVersion: '',
            fwUpdateRequestedAt: fwUpdateRequestedAt,
            isUpdating: false,
            status: FwUpdateStatus.unknown,
          );
        }

        final fwStatus = currentDevice.fwStatus(
            latestFwVersion!, fwUpdateRequestedAt.value != null);

        final isUpdating = fwStatus == FwUpdateStatus.updating;

        return isBanner
            ? _buildBanner(
                context: context,
                ref: ref,
                device: currentDevice,
                latestFwVersion: latestFwVersion!,
                fwUpdateRequestedAt: fwUpdateRequestedAt,
                isUpdating: isUpdating,
                status: fwStatus,
              )
            : _buildText(
                context: context,
                ref: ref,
                device: currentDevice,
                latestFwVersion: latestFwVersion!,
                fwUpdateRequestedAt: fwUpdateRequestedAt,
                isUpdating: isUpdating,
                status: fwStatus,
              );
      },
    );
  }

  /// 詳細画面用バナー
  Widget _buildBanner({
    required BuildContext context,
    required WidgetRef ref,
    required Device device,
    required String latestFwVersion,
    required ValueNotifier<int?> fwUpdateRequestedAt,
    required bool isUpdating,
    required FwUpdateStatus status,
  }) {
    if (status == FwUpdateStatus.unknown || status == FwUpdateStatus.latest) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => _handleTap(
          context: context,
          ref: ref,
          device: device,
          latestFwVersion: latestFwVersion,
          fwUpdateRequestedAt: fwUpdateRequestedAt,
          isUpdating: isUpdating,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.lightOrange.withValues(alpha: 0.8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                status.label,
                style: AppTextStyle.body2.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 詳細設定画面用
  Widget _buildText({
    required BuildContext context,
    required WidgetRef ref,
    required Device device,
    required String latestFwVersion,
    required ValueNotifier<int?> fwUpdateRequestedAt,
    required bool isUpdating,
    required FwUpdateStatus status,
  }) {
    // dirty(FW直書き)が見えないようにするためめ除去
    String formatVersion(String? v) => (v ?? '--').replaceAll('-dirty', '');

    // unknown / latest はテキストのみ
    if (status == FwUpdateStatus.unknown || status == FwUpdateStatus.latest) {
      final fwVersion = formatVersion(device.fwVersion);
      final displayVersion = fwVersion.isEmpty ? '--' : fwVersion;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(displayVersion, style: AppTextStyle.body1TextGrey),
        ),
      );
    }

    // updateAvailable / updating はオレンジのアイコン＋ラベル＋バージョン＋ > アイコン（設定画面用：バージョンは改行可）
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(
        context: context,
        ref: ref,
        device: device,
        latestFwVersion: latestFwVersion,
        fwUpdateRequestedAt: fwUpdateRequestedAt,
        isUpdating: isUpdating,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.secondary, size: 8),
                const SizedBox(width: 4),
                Text(
                  status.shortLabel,
                  style: AppTextStyle.body4.copyWith(
                    color: AppColors.secondary,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                formatVersion(device.fwVersion),
                style: AppTextStyle.body1TextGrey,
                softWrap: true,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              CupertinoIcons.chevron_forward,
              size: 20,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap({
    required BuildContext context,
    required WidgetRef ref,
    required Device device,
    required String latestFwVersion,
    required ValueNotifier<int?> fwUpdateRequestedAt,
    required bool isUpdating,
  }) {
    if (!isUpdating) {
      _showFirmwareUpdateConfirmationDialog(
        context,
        ref,
        device,
        latestFwVersion,
        fwUpdateRequestedAt,
      );
    } else {
      _showProgressDialog(
        context: context,
        device: this.device,
        latestFwVersion: latestFwVersion,
        fwUpdateRequestedAt: fwUpdateRequestedAt,
      );
    }
  }

  /// ファームウェアアップデート確認ダイアログ → リクエスト → 進捗表示
  void _showFirmwareUpdateConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    Device device,
    String latestFwVersion,
    ValueNotifier<int?> fwUpdateRequestedAt,
  ) {
    if (homeId == null) return;

    BasicDialog.show(
      context: context,
      title: AppStrings.fwUpdateDialogTitle,
      content: Text(
        "${AppStrings.fwUpdateDialogContent}\n\n${AppStrings.fwUpdateDialogCaution}",
        style: AppTextStyle.body1TextGrey,
      ),
      buttons: [
        BasicDialogButton.ok(
          text: AppStrings.fwUpdateDialogButton,
          autoClose: false,
          callback: () async {
            await ref.read(deviceServiceProvider.notifier).requestFwUpdate(
                  homeId: homeId!,
                  deviceId: device.id,
                  successCallback: () async {
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    await FwUpdateRequestedAtStorage.setWithTimestamp(
                        device.id, timestamp);
                    fwUpdateRequestedAt.value = timestamp;
                    if (Navigator.of(context).canPop())
                      Navigator.of(context).pop();
                    // 進捗ダイアログ表示
                    Future.delayed(Duration.zero, () {
                      _showProgressDialog(
                        context: context,
                        device: this.device,
                        latestFwVersion: latestFwVersion,
                        fwUpdateRequestedAt: fwUpdateRequestedAt,
                      );
                    });
                  },
                  errorCallback: (msg, code) {
                    BasicDialog.showError(
                      context: context,
                      errorMessage: msg,
                      errorCode: code,
                    );
                  },
                );
          },
        ),
        BasicDialogButton.cancel(),
      ],
    );
  }

  /// 進捗ダイアログ
  void _showProgressDialog({
    required BuildContext context,
    required ValueNotifier<Device?> device,
    required String latestFwVersion,
    required ValueNotifier<int?> fwUpdateRequestedAt,
  }) {
    final progress = ValueNotifier<double>(0.0);
    final startedAt = fwUpdateRequestedAt.value != null
        ? DateTime.fromMillisecondsSinceEpoch(fwUpdateRequestedAt.value!)
        : DateTime.now();
    // 初期進捗を開始時刻から算出（共通ロジック）
    progress.value = _computeInitialProgress(startedAt);
    bool active = true;
    final progressTimer = _startProgressTimer(
      progress: progress,
      isActive: () => active,
    );

    // ダイアログのNavigatorStateを保持（確実にこのダイアログだけを閉じるため）
    NavigatorState? dialogNavigator;

    // 呼び出し側が提供するdevice(ValueNotifier)の変更を監視（ダイアログ表示中の完了検知）
    // 完了判定とトースト表示はbuild側のuseEffectで行われるため、ここではダイアログクローズのみ
    Future<void> handleDeviceUpdate(Device? d) async {
      if (!active || d == null) return;
      final status = d.fwStatus(latestFwVersion);
      if (status == FwUpdateStatus.latest) {
        active = false;
        progress.value = 1.0;
        progressTimer.cancel();
        await Future<void>.delayed(const Duration(milliseconds: 400));
        if (dialogNavigator != null && dialogNavigator!.canPop()) {
          dialogNavigator!.pop();
        }
        // 完了判定とトースト表示はbuild側のuseEffectで行われるため、ここでは何もしない
      }
    }

    void deviceListener() {
      handleDeviceUpdate(device.value);
    }

    // 監視開始
    device.addListener(deviceListener);
    // 初期の値でも判定
    unawaited(handleDeviceUpdate(device.value));

    // fwUpdateRequestedAtの変化を監視してダイアログを閉じる（完了/タイムアウト検知）
    void fwUpdateRequestedAtListener() {
      if (!active) return;

      if (fwUpdateRequestedAt.value == null && progress.value > 0) {
        active = false;
        progressTimer.cancel();
        if (dialogNavigator != null && dialogNavigator!.canPop()) {
          dialogNavigator!.pop();
        }
      }
    }

    // fwUpdateRequestedAtの変化を監視開始
    fwUpdateRequestedAt.addListener(fwUpdateRequestedAtListener);

    final future = BasicDialog.show(
      context: context,
      title: AppStrings.fwUpdateDialogTitle,
      barrierDismissible: false,
      onNavigatorReady: (navigator) {
        dialogNavigator = navigator;
      },
      content: ValueListenableBuilder<double>(
        valueListenable: progress,
        builder: (_, progressValue, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 8,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  backgroundColor: const Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "${(progressValue * 100).toInt()}%",
                style: AppTextStyle.heading0.copyWith(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 64),
              Text(
                AppStrings.fwUpdateDialogCaution,
                style: AppTextStyle.body1TextGrey,
              ),
            ],
          );
        },
      ),
      buttons: [
        BasicDialogButton.ok(text: AppStrings.close),
      ],
    );

    future.whenComplete(() {
      active = false;
      progressTimer.cancel();
      device.removeListener(deviceListener);
      fwUpdateRequestedAt.removeListener(fwUpdateRequestedAtListener);
    });
  }
}
