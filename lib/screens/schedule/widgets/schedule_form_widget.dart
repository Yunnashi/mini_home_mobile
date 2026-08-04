import 'package:flutter/material.dart';
import 'package:mini_home/core/widgets/glass_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/app_surface_card.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/widgets/time_picker.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:mini_home/screens/schedule/widgets/weekday_selector.dart';

class ScheduleFormWidget extends HookWidget {
  final ValueNotifier<Schedule> initialSchedule;
  final ValueChanged<Schedule>? onScheduleChanged;
  final void Function(bool Function())? onValidatorReady;

  final VoidCallback onSavePressed;

  const ScheduleFormWidget({
    super.key,
    required this.initialSchedule,
    required this.onSavePressed,
    this.onScheduleChanged,
    this.onValidatorReady,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // バリデーション用のエラーメッセージ状態
    final timeRangeError = useState<String?>(null);
    final weekdayError = useState<String?>(null);
    // 曜日指定スイッチ: on のときのみ WeekdaySelector を表示。7つ（毎日）のときは off
    final isWeekdaySpecificationEnabled = useState(
        initialSchedule.value.weekdays.isNotEmpty &&
            initialSchedule.value.weekdays.length != Weekday.values.length);

    // 文字列をTimeOfDayに変換する
    TimeOfDay parseTime(String timeString) {
      if (timeString.length == 4) {
        final hour = int.parse(timeString.substring(0, 2));
        final minute = int.parse(timeString.substring(2, 4));
        return TimeOfDay(hour: hour, minute: minute);
      }
      return const TimeOfDay(hour: 8, minute: 0);
    }

    // TimeOfDayを文字列に変換する
    String formatTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour$minute';
    }

    // 同じ時間が設定されている場合はエラー
    void validateTimeRange() {
      if (initialSchedule.value.startAt == initialSchedule.value.finishAt) {
        timeRangeError.value = AppStrings.scheduleTimeRangeError;
      } else {
        timeRangeError.value = null;
      }
    }

    // 曜日が選択されていない場合はエラー
    void validateWeekdaySelection() {
      if (initialSchedule.value.weekdays.isEmpty) {
        weekdayError.value = AppStrings.scheduleWeekdayRequiredError;
      } else {
        weekdayError.value = null;
      }
    }

    void setEveryDay() {
      initialSchedule.value = initialSchedule.value.copyWith(
        weekdays: Weekday.values,
      );
      onScheduleChanged?.call(initialSchedule.value);
    }

    // バリデーション実行関数
    bool validateForm() {
      validateTimeRange();
      if (isWeekdaySpecificationEnabled.value) {
        validateWeekdaySelection();
      } else {
        weekdayError.value = null;
        // 曜日指定OFFのときは強制的に毎日にする
        setEveryDay();
      }
      return timeRangeError.value == null && weekdayError.value == null;
    }

    // 親ウィジェットにバリデーション関数を渡す
    useEffect(() {
      onValidatorReady?.call(validateForm);
      return null;
    }, []);

    // 時間選択ウィジェット
    Widget timePickerSectionWidget({
      required String label,
      required String timeValue,
      required bool isStartTime,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.body1TextGrey),
          const SizedBox(height: 4),
          AppSurfaceCard(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: TimePicker(
              initialTime: parseTime(timeValue),
              onTimeChanged: (time) {
                final timeString = formatTime(time);
                initialSchedule.value = isStartTime
                    ? initialSchedule.value.copyWith(startAt: timeString)
                    : initialSchedule.value.copyWith(finishAt: timeString);
                onScheduleChanged?.call(initialSchedule.value);
                validateTimeRange();
              },
            ),
          ),
        ],
      );
    }

    final formContent = SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FB),
              Color(0xFFF0F2F5),
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 124),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 曜日指定 On/Off スイッチ
                  Text(
                    AppStrings.switchWeekday,
                    style: AppTextStyle.body1TextGrey,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.95,
                        alignment: Alignment.centerLeft,
                        child: CupertinoSwitch(
                          value: isWeekdaySpecificationEnabled.value,
                          activeTrackColor: AppColors.primary,
                          onChanged: (value) {
                            isWeekdaySpecificationEnabled.value = value;
                            if (!value) {
                              weekdayError.value = null;
                            } else {
                              validateWeekdaySelection();
                            }
                          },
                        ),
                      ),
                      if (!isWeekdaySpecificationEnabled.value) ...[
                        const SizedBox(width: 16),
                        Text(AppStrings.repeatEveryday,
                            style: AppTextStyle.body1),
                      ]
                    ],
                  ),

                  if (isWeekdaySpecificationEnabled.value) ...[
                    const SizedBox(height: 12),
                    WeekdaySelector(
                      selectedWeekdays: initialSchedule.value.weekdays.toSet(),
                      onWeekdaysChanged: (weekdays) {
                        initialSchedule.value = initialSchedule.value.copyWith(
                          weekdays: weekdays.toList(),
                        );
                        onScheduleChanged?.call(initialSchedule.value);
                        validateWeekdaySelection();
                      },
                    ),
                    if (weekdayError.value != null)
                      Text(
                        weekdayError.value!,
                        style: AppTextStyle.body3TextRed,
                      ),
                    const SizedBox(height: 16),
                  ] else ...[
                    const SizedBox(height: 12),
                  ],
                  // 開始時間
                  timePickerSectionWidget(
                    label: AppStrings.startTime,
                    timeValue: initialSchedule.value.startAt,
                    isStartTime: true,
                  ),
                  const SizedBox(height: 16),
                  // 終了時間
                  timePickerSectionWidget(
                    label: AppStrings.endTime,
                    timeValue: initialSchedule.value.finishAt,
                    isStartTime: false,
                  ),
                  const SizedBox(height: 8),
                  // 時間範囲エラーメッセージ
                  if (timeRangeError.value != null)
                    Text(
                      timeRangeError.value!,
                      style: AppTextStyle.body3TextRed,
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Stack(
      children: [
        Positioned.fill(child: formContent),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _SaveButtonSection(onPressed: onSavePressed),
        ),
      ],
    );
  }
}

/// フォーム内の保存ボタンエリア（ボタン周りは半透明で背面が透ける）
class _SaveButtonSection extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButtonSection({required this.onPressed});

  static const _padding = EdgeInsets.fromLTRB(24, 16, 24, 24);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = _padding.top + _padding.bottom + 56;
        return GlassContainer(
          width: width,
          height: height,
          color: AppColors.white,
          radius: 0,
          padding: _padding,
          child: SizedBox(
            width: double.infinity,
            child: BasicButton.buildLarge(
              onPressed: onPressed,
              text: AppStrings.save,
            ),
          ),
        );
      },
    );
  }
}
