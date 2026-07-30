import 'package:flutter/material.dart';
import 'package:mini_home/utils/double_utils.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/features/usage/models/usage.dart';
import 'package:mini_home/utils/string_utils.dart';

class UsageCard extends StatelessWidget {
  final Usage usage;
  final VoidCallback? onTap;

  const UsageCard({
    super.key,
    required this.usage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              usage.createdAt
                  .formatDateTimeText(type: FormatType.monthDayWithSeconds),
              style: AppTextStyle.body2TextGrey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: SizedBox(
                width: double.infinity,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(32),
                    2: FlexColumnWidth()
                  },
                  children: [
                    TableRow(
                      children: [
                        Text(AppStrings.activityTypeTitle,
                            style: AppTextStyle.body3TextGrey),
                        const SizedBox(width: 32),
                        Text(AppStrings.activityType(usage.activityType),
                            style: AppTextStyle.body2),
                      ],
                    ),
                    const TableRow(
                      children: [
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(AppStrings.activityDurationTitle,
                            style: AppTextStyle.body3TextGrey),
                        const SizedBox(width: 32),
                        Text(usage.durationSeconds.toDouble().formatDuration(),
                            style: AppTextStyle.body2),
                      ],
                    ),
                    const TableRow(
                      children: [
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(AppStrings.activityEnergyTitle,
                            style: AppTextStyle.body3TextGrey),
                        const SizedBox(width: 32),
                        Text("${AppStrings.formatDouble(usage.energyKwh)} kWh",
                            style: AppTextStyle.body2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
