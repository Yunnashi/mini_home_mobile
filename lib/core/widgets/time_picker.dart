import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TimePicker extends HookWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onTimeChanged;

  const TimePicker({
    super.key,
    required this.initialTime,
    this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // TimeOfDayからDateTimeに変換
    final now = DateTime.now();
    final initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      initialTime.hour,
      initialTime.minute,
    );

    final selectedDateTime = useState(initialDateTime);

    void handleTimeChanged(DateTime dateTime) {
      selectedDateTime.value = dateTime;

      final timeOfDay = TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      );
      onTimeChanged?.call(timeOfDay);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5.51),
      child: Container(
        height: 160,
        color: Colors.transparent,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: selectedDateTime.value,
          use24hFormat: true,
          onDateTimeChanged: handleTimeChanged,
        ),
      ),
    );
  }
}
