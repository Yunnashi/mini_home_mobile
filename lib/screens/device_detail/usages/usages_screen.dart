import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/services/smart_device_service.dart';
import 'package:mini_home/features/usage/models/usage.dart';
import 'package:mini_home/features/usage/services/usage_service.dart';
import 'package:mini_home/screens/device_detail/usage_list_section/usage_grouping_widget.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:mini_home/utils/string_utils.dart';

/// 月でグループ化した利用履歴の型
class _UsageGroup {
  final int yearMonthKey;
  final String monthLabel;
  final List<Usage> usages;

  _UsageGroup({
    required this.yearMonthKey,
    required this.monthLabel,
    required this.usages,
  });
}

class UsagesScreen extends HookConsumerWidget {
  final int deviceId;

  const UsagesScreen({super.key, required this.deviceId});

  static const int _pageSize = 10;
  static const double _loadMoreThreshold = 200;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceAsync = ref.watch(smartDeviceServiceProvider(deviceId));
    final device = useState<Device?>(null);
    final groups = useState<List<_UsageGroup>>([]);
    final isLoading = useState<bool>(true);
    final isLoadingMore = useState<bool>(false);
    final hasMore = useState<bool>(true);
    final currentPage = useState<int>(1);
    final errorMessage = useState<String?>(null);
    final scrollController = useScrollController();

    void handleFetchError(String? message, String? code) {
      safeDebugPrint("[ERROR] $message, code: $code");
      errorMessage.value =
          "${AppStrings.deviceDetailFetchError}\n$message${code != null ? " ($code)" : ""}";
    }

    int yearMonthKey(Usage u) {
      if (u.createdAt.isNullOrEmpty) return 0;
      try {
        final dt = DateTime.parse(u.createdAt!);
        return dt.year * 12 + dt.month;
      } catch (_) {
        return 0;
      }
    }

    String monthLabel(Usage u) {
      if (u.createdAt.isNullOrEmpty) return '';
      final formatted = u.createdAt!.formatDateTimeText(
        type: FormatType.yearMonthOnly,
        defaultValue: '',
      );
      return AppStrings.usageHistoryMonthGroup(formatted);
    }

    /// フラットなリストを月別グループに変換（初回・単体バッチ用）
    List<_UsageGroup> groupByMonth(List<Usage> usages) {
      if (usages.isEmpty) return [];

      final result = <_UsageGroup>[];
      _UsageGroup? currentGroup;
      int? currentKey;

      for (final u in usages) {
        final key = yearMonthKey(u);
        if (currentGroup != null && currentKey == key) {
          currentGroup.usages.add(u);
        } else {
          final label = monthLabel(u);
          currentGroup = _UsageGroup(
            yearMonthKey: key,
            monthLabel: label,
            usages: [u],
          );
          currentKey = key;
          result.add(currentGroup);
        }
      }

      return result;
    }

    /// 新規取得分を既存グループにマージする。
    /// 既存の最後のグループの月と新規先頭が同じ場合は、そのグループにマージする。
    List<_UsageGroup> mergeGroups(
        List<_UsageGroup> existing, List<Usage> newUsages) {
      if (newUsages.isEmpty) return existing;
      if (existing.isEmpty) return groupByMonth(newUsages);

      final result = List<_UsageGroup>.from(existing);
      _UsageGroup currentGroup = result.last;
      int currentKey = currentGroup.yearMonthKey;

      for (final u in newUsages) {
        final key = yearMonthKey(u);
        if (currentKey == key) {
          currentGroup.usages.add(u);
        } else {
          final label = monthLabel(u);
          currentGroup = _UsageGroup(
            yearMonthKey: key,
            monthLabel: label,
            usages: [u],
          );
          currentKey = key;
          result.add(currentGroup);
        }
      }

      return result;
    }

    Future<void> fetchUsages({bool loadMore = false}) async {
      final d = device.value;
      if (d == null) return;

      if (loadMore) {
        if (isLoadingMore.value || !hasMore.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        groups.value = [];
        currentPage.value = 1;
        hasMore.value = true;
      }

      final page = loadMore ? currentPage.value : 1;

      await ref.read(usageServiceProvider.notifier).getUsagesByDevice(
            homeId: d.homeId,
            externalDeviceId: d.externalDeviceId,
            pageSize: _pageSize,
            pageNum: page,
            successCallback: (usages) {
              if (loadMore) {
                if (usages.length < _pageSize) {
                  hasMore.value = false;
                }
                currentPage.value = page + 1;
                groups.value = mergeGroups(groups.value, usages);
                isLoadingMore.value = false;
              } else {
                groups.value = groupByMonth(usages);
                if (usages.length < _pageSize) {
                  hasMore.value = false;
                } else {
                  currentPage.value = 2;
                }
                isLoading.value = false;
              }
            },
            errorCallback: (msg, code) {
              if (loadMore) {
                isLoadingMore.value = false;
              } else {
                isLoading.value = false;
              }
              handleFetchError(msg, code);
            },
          );
    }

    useEffect(() {
      void onScroll() {
        if (!hasMore.value || isLoadingMore.value) return;
        if (!scrollController.hasClients) return;
        final pos = scrollController.position;
        if (pos.pixels >= pos.maxScrollExtent - _loadMoreThreshold) {
          fetchUsages(loadMore: true);
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [hasMore.value, isLoadingMore.value]);

    useEffect(() {
      deviceAsync.whenData((value) async {
        device.value = value;
        await fetchUsages();
      });
      if (deviceAsync.hasError) {
        errorMessage.value = AppStrings.deviceDetailFetchError;
        isLoading.value = false;
      }
      return null;
    }, [deviceAsync]);

    return BasicScreen(
      appBar: BasicAppBar.buildPushStyle(
        context: context,
        titleAppBar: AppStrings.usageHistoryTitle,
        onBackPressed: () => GoRouter.of(context).pop(),
      ),
      body: deviceAsync.when(
        data: (_) {
          if (errorMessage.value != null) {
            return RefreshIndicator(
              onRefresh: () async {
                errorMessage.value = null;
                await ref
                    .read(smartDeviceServiceProvider(deviceId).notifier)
                    .refresh();
                await fetchUsages();
              },
              child: ErrorMessageView(message: errorMessage.value!),
            );
          }
          if (isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.grey));
          }
          if (groups.value.isEmpty) {
            return Center(
              child: Text(
                AppStrings.usageHistoryEmpty,
                style: AppTextStyle.body2TextGrey,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              errorMessage.value = null;
              await ref
                  .read(smartDeviceServiceProvider(deviceId).notifier)
                  .refresh();
              await fetchUsages();
            },
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: groups.value.length + (isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= groups.value.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }
                final g = groups.value[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.monthLabel, style: AppTextStyle.heading1),
                      const SizedBox(height: 16),
                      UsageGroupingWidget(usages: g.usages),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.grey),
        ),
        error: (e, _) {
          safeDebugPrint("Error loading usages screen: $e");
          return RefreshIndicator(
            onRefresh: () async {
              errorMessage.value = null;
              await ref
                  .read(smartDeviceServiceProvider(deviceId).notifier)
                  .refresh();
            },
            child: ErrorMessageView(message: AppStrings.deviceDetailFetchError),
          );
        },
      ),
    );
  }
}
