import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/device/repositories/device_repository.dart';

/// デバイスの再起動用ウィジェット。設定画面の再起動行で使用。
/// 表示: deviceSettingDoReboot のテキスト + chevron。
/// タップ時: API 経由でデバイス再起動をリクエストする。
/// 処理中はスピナー表示、失敗時はダイアログ。
class DeviceRestartWidget extends HookConsumerWidget {
  const DeviceRestartWidget({
    super.key,
    required this.homeId,
    required this.deviceId,
  });

  final int homeId;
  final int deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRebooting = useState(false);

    Future<void> runReboot() async {
      if (isRebooting.value) return;
      isRebooting.value = true;
      try {
        final repo = ref.read(deviceRepositoryProvider);
        final result = await repo.requestDeviceRestart(
          homeId: homeId,
          deviceId: deviceId,
        );
        if (!context.mounted) return;
        if (result is Failure) {
          await BasicDialog.showError(
            context: context,
            customMessage: result.message ?? AppStrings.deviceDetailUpdateError,
            title: AppStrings.error,
          );
          return;
        }
        BasicToast.showToast(
          AppStrings.deviceSettingRebootSuccess,
          ToastType.success,
        );
      } finally {
        if (context.mounted) {
          isRebooting.value = false;
        }
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isRebooting.value ? null : () => runReboot(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isRebooting.value)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          else ...[
            Flexible(
              child: Text(
                AppStrings.deviceSettingDoReboot,
                style: AppTextStyle.body2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              CupertinoIcons.chevron_forward,
              size: 20,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ],
      ),
    );
  }
}
