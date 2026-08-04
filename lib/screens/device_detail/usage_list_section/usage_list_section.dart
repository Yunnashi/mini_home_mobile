import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/skeleton.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/usage/models/usage.dart';
import 'package:mini_home/screens/device_detail/usage_list_section/usage_grouping_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UsageListSection extends StatelessWidget {
  final int? homeId;
  final ValueNotifier<Device?> device;
  final AsyncValue<List<Usage>> usageListAsync;
  final Future<void> Function(int homeId, String externalDeviceId,
      {int pageSize}) fetchUsageList;
  final bool isLoading;

  const UsageListSection({
    Key? key,
    required this.homeId,
    required this.device,
    required this.usageListAsync,
    required this.fetchUsageList,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // タイトル
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Skeleton(height: 30),
          )
        else if ((usageListAsync.value ?? []).isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.deviceDetailLatestUsage,
                  style: AppTextStyle.body1),
              TextButton(
                onPressed: () {
                  if (device.value != null) {
                    context.push('/device-detail/${device.value!.id}/usages');
                  }
                },
                child: Text(AppStrings.deviceDetailMoreUsage,
                    style: AppTextStyle.body3TextLink),
              ),
            ],
          ),
        // 利用履歴カード一覧
        if (isLoading)
          const Skeleton(height: 120)
        else if ((usageListAsync.value ?? []).isNotEmpty)
          UsageGroupingWidget(usages: usageListAsync.value!),
      ],
    );
  }
}
