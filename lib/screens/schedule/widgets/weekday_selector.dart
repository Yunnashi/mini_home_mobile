import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';

class WeekdaySelector extends StatelessWidget {
  final Set<Weekday> selectedWeekdays;
  final ValueChanged<Set<Weekday>>? onWeekdaysChanged;

  const WeekdaySelector({
    super.key,
    required this.selectedWeekdays,
    this.onWeekdaysChanged,
  });

  static const List<Weekday> _weekdayValues = [
    Weekday.mon,
    Weekday.tue,
    Weekday.wed,
    Weekday.thu,
    Weekday.fri,
    Weekday.sat,
    Weekday.sun,
  ];

  void _toggleWeekday(int weekday) {
    final weekdayEnum = _weekdayValues[weekday];
    final newSelection = Set<Weekday>.from(selectedWeekdays);
    if (newSelection.contains(weekdayEnum)) {
      newSelection.remove(weekdayEnum);
    } else {
      newSelection.add(weekdayEnum);
    }
    onWeekdaysChanged?.call(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isSelected = selectedWeekdays.contains(_weekdayValues[index]);
            return GestureDetector(
              onTap: () => _toggleWeekday(index),
              child: Container(
                width: 40,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.51),
                  color: isSelected ? AppColors.primary : null,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _weekdayValues[index].displayName,
                    style: AppTextStyle.body2.copyWith(
                      color: isSelected ? AppColors.white : AppColors.text,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // 選択された曜日の表示
        if (selectedWeekdays.isNotEmpty)
          Text(
            selectedWeekdays.frequencyDisplayString,
            style: AppTextStyle.body2TextGrey,
          ),
      ],
    );
  }
}
