import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:flutter/services.dart';
import 'package:mini_home/features/device/models/device.dart';

class ChargingAmpereEditDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final double maxChargingAmpere;
  final ValueNotifier<double> selectedChargingKW;
  final Future<void> Function() onSave;

  const ChargingAmpereEditDialog({
    super.key,
    required this.formKey,
    required this.maxChargingAmpere,
    required this.selectedChargingKW,
    required this.onSave,
  });

  // minは6A, maxはmaxChargingAmpere, 0.2kW刻み
  double get minKw => 6.0.toKw();
  double get maxKw => maxChargingAmpere.toKw();
  int get divisions => ((maxKw - minKw) / 0.2).round();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder<double>(
            valueListenable: selectedChargingKW,
            builder: (context, value, child) {
              // kW→A変換: 1kW=5A
              final selectedChargingAmpere =
                  selectedChargingKW.value.toAmpere();
              // TODO: ほかでも同じ様なSliderを利用する可能性があればWidgetを分離する
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedChargingKW.value.toStringAsFixed(1),
                        style: AppTextStyle.heading0,
                      ),
                      Text(
                        " kW (${AppStrings.formatDouble(selectedChargingAmpere)}A)",
                        style: AppTextStyle.body1.copyWith(
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${minKw.toStringAsFixed(1)}kW",
                        style: AppTextStyle.body4TextGrey,
                      ),
                      Text(
                        "${maxKw.toStringAsFixed(1)}kW",
                        style: AppTextStyle.body4TextGrey,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 20,
                          padding: EdgeInsets.zero,
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor:
                              AppColors.primary.withValues(alpha: 0.2),
                          thumbColor: AppColors.white,
                          overlayColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 20.0),
                        ),
                        child: Slider(
                          value: value.clamp(minKw, maxKw),
                          min: minKw,
                          max: maxKw,
                          divisions: divisions,
                          onChanged: (val) {
                            selectedChargingKW.value =
                                double.parse(val.toStringAsFixed(1));
                            HapticFeedback.selectionClick();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(divisions + 1, (index) {
                          // 濃いメモリは整数値のときに表示させる
                          final tickValue = double.parse(
                              (minKw + (index * 0.2)).toStringAsFixed(1));
                          final isInteger = tickValue % 1 == 0;
                          return Container(
                            width: 2,
                            height: 12,
                            color: isInteger
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.3),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showChargingAmpereEditDialog({
  required BuildContext context,
  required double maxChargingAmpere,
  required ValueNotifier<double> selectedChargingKW,
  required Future<void> Function() onSave,
}) {
  var prevChargingKW = selectedChargingKW.value;
  final formKey = GlobalKey<FormState>();
  return BasicDialog.show(
    context: context,
    title: AppStrings.deviceDetailChangeChargingAmpereTitle,
    content: ChargingAmpereEditDialog(
      formKey: formKey,
      maxChargingAmpere: maxChargingAmpere,
      selectedChargingKW: selectedChargingKW,
      onSave: onSave,
    ),
    barrierDismissible: false,
    // buttonsの真上に実行に関する注意喚起を入れるためbuttonsに配置。
    buttons: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.greyText, size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              AppStrings.deviceDetailChangeChargingAmpereNote,
              style: AppTextStyle.body3TextGrey,
            ),
          ),
        ],
      ),
      const SizedBox.shrink(),
      BasicDialogButton.ok(
        text: AppStrings.txtBtnChange,
        autoClose: false,
        callback: () {
          if (formKey.currentState?.validate() ?? false) {
            onSave();
          }
        },
      ),
      BasicDialogButton.cancel(
        callback: () {
          // 元の値に戻す
          selectedChargingKW.value = prevChargingKW;
        },
      ),
    ],
  );
}
