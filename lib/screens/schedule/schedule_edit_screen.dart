import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/screens/schedule/widgets/schedule_form_widget.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:mini_home/features/schedule/services/schedule_service.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/utils/logger.dart';

class ScheduleEditScreen extends HookConsumerWidget {
  final Schedule schedule;
  final int deviceId;

  const ScheduleEditScreen({
    super.key,
    required this.schedule,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editingSchedule = useState<Schedule>(schedule);
    final authStateAsync = ref.watch(authStateServiceProvider);
    final validateForm = useRef<bool Function()?>(null);

    void saveSchedule(int? homeId) async {
      if (homeId == null) return;

      // バリデーション実行
      final isValid = validateForm.value?.call() ?? false;
      if (!isValid) return;

      final scheduleService = ref.read(scheduleServiceProvider.notifier);
      await scheduleService.updateSchedule(
        homeId: homeId,
        deviceId: deviceId,
        schedule: editingSchedule.value,
        successCallback: (updatedSchedule) {
          BasicToast.showToast(
              AppStrings.scheduleSaveSuccess, ToastType.success);
          context.pop(true);
        },
        errorCallback: (message, code) {
          BasicDialog.showError(
            context: context,
            title: AppStrings.scheduleSaveError,
            errorMessage: message,
            errorCode: code,
          );
        },
      );
    }

    void deleteSchedule(int? homeId) async {
      if (homeId == null) return;

      // 削除確認ダイアログを表示
      bool confirmed = false;

      await BasicDialog.show(
        context: context,
        title: AppStrings.scheduleDeleteConfirmTitle,
        content: Text(AppStrings.scheduleDeleteConfirmMessage),
        buttons: [
          BasicDialogButton.ok(
            callback: () {
              confirmed = true;
            },
          ),
          BasicDialogButton.cancel(),
        ],
      );

      // ユーザーがキャンセルした場合
      if (!confirmed) return;

      // スケジュール削除処理
      final scheduleService = ref.read(scheduleServiceProvider.notifier);
      await scheduleService.deleteSchedule(
        homeId: homeId,
        deviceId: deviceId,
        scheduleId: editingSchedule.value.id,
        successCallback: () {
          BasicToast.showToast(
              AppStrings.scheduleDeleteSuccess, ToastType.success);
          context.pop(true);
        },
        errorCallback: (message, code) {
          BasicDialog.showError(
            context: context,
            title: AppStrings.scheduleDeleteError,
            errorMessage: message,
            errorCode: code,
          );
        },
      );
    }

    return authStateAsync.when(
      data: (authState) {
        final homeId = authState.defaultHomeId;

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: BasicScreen(
            appBar: BasicAppBar.buildPresentStyleWithAction(
              context: context,
              titleAppBar: AppStrings.scheduleEditTitle,
              onBackPressed: () => context.pop(),
              rightIcon: TextButton(
                onPressed: () => deleteSchedule(homeId),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  minimumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.delete,
                  style: AppTextStyle.body1TextRed,
                ),
              ),
            ),
            body: ScheduleFormWidget(
              initialSchedule: editingSchedule,
              onScheduleChanged: (updatedSchedule) {
                editingSchedule.value = updatedSchedule;
              },
              onValidatorReady: (validator) {
                validateForm.value = validator;
              },
              onSavePressed: () => saveSchedule(homeId),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) {
        safeDebugPrint("Error loading schedule edit screen: $e");
        return const Text("");
      },
    );
  }
}
