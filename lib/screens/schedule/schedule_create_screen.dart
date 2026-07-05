import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:mini_home/features/schedule/services/schedule_service.dart';
import 'package:mini_home/screens/schedule/widgets/schedule_form_widget.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/utils/logger.dart';

class ScheduleCreateScreen extends HookConsumerWidget {
  final int deviceId;

  const ScheduleCreateScreen({super.key, required this.deviceId});

  final Schedule initialSchedule = const Schedule(
    id: '',
    startAt: '0800',
    finishAt: '0800',
    isEndsNextDay: false,
    weekdays: [],
    isEnabled: true,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = useState<Schedule>(initialSchedule);
    final authStateAsync = ref.watch(authStateServiceProvider);
    final validateForm = useRef<bool Function()?>(null);

    void saveSchedule(int? userGroupId) async {
      if (userGroupId == null) return;

      // バリデーション実行
      final isValid = validateForm.value?.call() ?? false;
      if (!isValid) {
        return;
      }

      final scheduleService = ref.read(scheduleServiceProvider.notifier);
      await scheduleService.createSchedule(
        userGroupId: userGroupId,
        deviceId: deviceId,
        schedule: schedule.value,
        successCallback: (schedule) {
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

    return authStateAsync.when(
      data: (authState) {
        final userGroupId = authState.defaultUserGroup?.id;

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: BasicScreen(
            appBar: BasicAppBar.buildPresentStyle(
              context: context,
              titleAppBar: AppStrings.scheduleCreateTitle,
              onBackPressed: () => context.pop(),
            ),
            body: ScheduleFormWidget(
              initialSchedule: schedule,
              onScheduleChanged: (updatedSchedule) {
                schedule.value = updatedSchedule;
              },
              onValidatorReady: (validator) {
                validateForm.value = validator;
              },
              onSavePressed: () => saveSchedule(userGroupId),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) {
        safeDebugPrint("Error loading schedule create screen: $e");
        return const Text("");
      },
    );
  }
}
