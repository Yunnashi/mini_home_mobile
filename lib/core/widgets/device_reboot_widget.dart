import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/features/device/repositories/device_repository.dart';
import 'package:mini_home/features/device/services/ella_ble_service.dart';
import 'package:mini_home/core/network/models/result.dart';

/// 充電器の再起動用ウィジェット。設定画面の再起動行で使用。
/// 表示: deviceSettingDoReboot のテキスト + chevron。
/// タップ時: BLE 検索 → challenge 取得 → API で OTP 取得 → デバイスに write の一連の再起動処理。
/// 処理中はスピナー表示、失敗時はダイアログ。
class DeviceRebootWidget extends HookConsumerWidget {
  const DeviceRebootWidget({
    super.key,
    required this.userGroupId,
    required this.deviceId,
    required this.externalDeviceId,
  });

  final int userGroupId;
  final int deviceId;
  final String externalDeviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRebooting = useState(false);

    Future<void> runReboot() async {
      if (isRebooting.value) return;
      isRebooting.value = true;
      try {
        final ble = ref.read(ellaBleServiceProvider);
        final found = await ble.search(context, externalDeviceId);
        if (!context.mounted) return;
        if (found) {
          final challenge = await ble.getChallenge(context);
          if (!context.mounted) return;
          if (challenge == null || challenge.isEmpty) {
            return;
          }
          final repo = ref.read(deviceRepositoryProvider);
          final result = await repo.fetchRebootOtp(
            userGroupId: userGroupId,
            deviceId: deviceId,
            deviceChallenge: challenge,
          );
          if (!context.mounted) return;
          if (result is Failure) {
            await BasicDialog.showError(
              context: context,
              customMessage: result.message ?? AppStrings.bleSearchFailed,
              title: AppStrings.error,
            );
            return;
          }
          final data = (result as Success).value as Map<String, dynamic>?;
          final otp = data?['otp'] as String?;
          if (otp == null || otp.isEmpty) {
            await BasicDialog.showError(
              context: context,
              customMessage: AppStrings.bleSearchFailed,
              title: AppStrings.error,
            );
            return;
          }
          final written = await ble.writeOtp(otp, context: context);
          if (!context.mounted) return;
          if (written && context.mounted) {
            BasicToast.showToast(
              AppStrings.deviceSettingRebootSuccess,
              ToastType.success,
            );
          }
        }
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
