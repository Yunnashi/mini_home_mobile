import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/skeleton.dart';
import 'package:mini_home/screens/device_detail/schedule_section/charging_schedule_card.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/router/router.dart';

class ScheduleSection extends StatelessWidget {
  final BuildContext context;
  final WidgetRef ref;
  final int? userGroupId;
  final ValueNotifier<Device?> device;
  final AsyncValue<List<Schedule>> scheduleListAsync;
  final Future<void> Function(int userGroupId, int deviceId) fetchScheduleList;
  final Future<void> Function({
    required int userGroupId,
    required int deviceId,
    required Schedule schedule,
    required bool isEnabled,
  }) updateScheduleEnabled;
  final bool isLoading;

  const ScheduleSection({
    super.key,
    required this.context,
    required this.ref,
    required this.userGroupId,
    required this.device,
    required this.scheduleListAsync,
    required this.fetchScheduleList,
    required this.updateScheduleEnabled,
    this.isLoading = false,
  });

  Future<void> handleScheduleNavigation(
      {required bool isCreate, Schedule? schedule}) async {
    bool? result;
    if (isCreate) {
      // スケジュール作成画面へ遷移
      result = await context.pushNamed(
        AppRoutes.scheduleCreate,
        pathParameters: {
          'deviceId': device.value?.id.toString() ?? '',
        },
      );
    } else {
      // スケジュール編集画面へ遷移
      final target = schedule;
      if (target == null) return;
      result = await context.pushNamed(
        AppRoutes.scheduleEdit,
        pathParameters: {
          'deviceId': device.value?.id.toString() ?? '',
        },
        extra: target,
      );
    }

    if (userGroupId == null || device.value == null) return;

    // 保存・削除が成功した場合のみスケジュールリストを再取得
    if (result == true) {
      await fetchScheduleList(userGroupId!, device.value!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // タイトル
        Text(AppStrings.deviceDetailChargingSchedule,
            style: AppTextStyle.body1),
        SizedBox(height: 8),
        isLoading
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Skeleton(height: 80),
              )
            : _buildScheduleScroll(context),
        // 説明文
        Text(
          AppStrings.deviceDetailChargingScheduleDescription,
          style: AppTextStyle.body4TextGrey,
        ),
      ],
    );
  }

  static const double _cardGap = 8.0;
  static const double _cardWidthOffset = 99.0; // 画面幅から引くので、次のカードが少し見える

  Widget _buildScheduleScroll(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = screenWidth - _cardWidthOffset;
    final scheduleList = scheduleListAsync.value ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 80,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < scheduleList.length; i++) ...[
                  if (i > 0) const SizedBox(width: _cardGap),
                  SizedBox(
                    width: cardWidth,
                    child: ChargingScheduleCard(
                      schedule: scheduleList[i],
                      onTap: () async {
                        await handleScheduleNavigation(
                            isCreate: false, schedule: scheduleList[i]);
                      },
                      onToggleChanged: () {
                        updateScheduleEnabled(
                          userGroupId: userGroupId!,
                          deviceId: device.value!.id,
                          schedule: scheduleList[i],
                          isEnabled: !scheduleList[i].isEnabled,
                        );
                      },
                    ),
                  ),
                ],
                if (scheduleList.isNotEmpty) const SizedBox(width: _cardGap),
                SizedBox(
                  width: cardWidth,
                  child: _addCard(
                    onTap: () async {
                      await handleScheduleNavigation(isCreate: true);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addCard({required VoidCallback onTap}) {
    final double borderRadius = 5.51;
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: [2, 2],
        radius: Radius.circular(borderRadius),
        color: AppColors.border,
        padding: const EdgeInsets.all(1),
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(5.51),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                color: AppColors.greyText,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.scheduleCreateTitle,
                style: AppTextStyle.body1TextGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
