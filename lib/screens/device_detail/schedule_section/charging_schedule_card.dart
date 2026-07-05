import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';

class ChargingScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback? onToggleChanged;
  final VoidCallback? onTap;

  const ChargingScheduleCard({
    super.key,
    required this.schedule,
    this.onToggleChanged,
    this.onTap,
  });

  String _formatScheduleTime(Schedule schedule) {
    final startHour = schedule.startAt.substring(0, 2);
    final startMinute = schedule.startAt.substring(2, 4);
    final finishHour = schedule.finishAt.substring(0, 2);
    final finishMinute = schedule.finishAt.substring(2, 4);

    if (schedule.isEndsNextDay) {
      return "$startHour:$startMinute 〜 ${AppStrings.nextDay} $finishHour:$finishMinute";
    } else {
      return "$startHour:$startMinute 〜 $finishHour:$finishMinute";
    }
  }

  String _formatScheduleFrequency(Schedule schedule) {
    return schedule.weekdays.frequencyDisplayString;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.51),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(
                Icons.date_range,
                color: AppColors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatScheduleTime(schedule),
                    style: AppTextStyle.body1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatScheduleFrequency(schedule),
                    style: AppTextStyle.body3TextGrey,
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: schedule.isEnabled,
                activeTrackColor: AppColors.primary,
                onChanged: (value) {
                  onToggleChanged?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
