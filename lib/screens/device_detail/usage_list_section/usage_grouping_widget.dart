import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/features/usage/models/usage.dart';
import 'package:mini_home/screens/device_detail/usage_list_section/usage_card.dart';

/// 月でグループ化済みの [Usage] リストを1ブロックとして表示する共通Widget。
/// 呼び出し元が grouping した array を渡す。月ラベルは呼び出し元で外側に表示する。
class UsageGroupingWidget extends StatelessWidget {
  final List<Usage> usages;

  const UsageGroupingWidget({
    super.key,
    required this.usages,
  });

  @override
  Widget build(BuildContext context) {
    if (usages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.51),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...usages.asMap().entries.expand((entry) {
            final index = entry.key;
            final usage = entry.value;
            return [
              if (index > 0) const Divider(height: 24, thickness: 1),
              Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  bottom: 5.0,
                ),
                child: UsageCard(usage: usage),
              ),
            ];
          }),
        ],
      ),
    );
  }
}
