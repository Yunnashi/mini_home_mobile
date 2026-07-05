import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/constants/custom_errors.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/features/device/repositories/charging_ampere_storage_repository.dart';
import 'package:mini_home/features/device/services/device_service.dart';
import 'package:mini_home/features/device/services/fw_update_info_service.dart';
import 'package:mini_home/router/app_route_observer.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/usage/models/usage.dart';
import 'package:mini_home/features/usage/services/usage_service.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:mini_home/features/schedule/services/schedule_service.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/fw_update_section.dart';
import 'package:mini_home/screens/device_detail/usage_list_section/usage_list_section.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:mini_home/utils/route_aware_event.dart';
import 'package:mini_home/screens/device_detail/device_info_section/device_info_section.dart';
import 'package:mini_home/screens/device_detail/schedule_section/schedule_section.dart';

class DeviceDetailScreen extends HookConsumerWidget {
  final int deviceId;
  DeviceDetailScreen({Key? key, required this.deviceId}) : super(key: key);

  void _onBack(BuildContext context) {
    GoRouter.of(context).pop();
  }

  Future<void> _handlePendingChargingAmpere({
    required int deviceId,
    required double? currentChargingAmpere,
    required ValueNotifier<double?> pendingChargingAmpere,
  }) async {
    final pendingData = await ChargingAmpereStorage.getWithTimestamp(deviceId);
    if (pendingData == null) {
      pendingChargingAmpere.value = null;
      await ChargingAmpereStorage.clear(deviceId);
      return;
    }

    final double pendingAmpere = pendingData['ampere'];
    // 取得した値が一致した場合はpending解除
    if (pendingAmpere == currentChargingAmpere) {
      pendingChargingAmpere.value = null;
      await ChargingAmpereStorage.clear(deviceId);
      return;
    }

    final int timestamp = pendingData['timestamp'];
    final now = DateTime.now().millisecondsSinceEpoch;
    const int fifteenMinutesMs = 900000;
    // 15分以上経過していたらpending解除
    if (now - timestamp > fifteenMinutesMs) {
      pendingChargingAmpere.value = null;
      await ChargingAmpereStorage.clear(deviceId);
      return;
    }

    // まだpending状態
    pendingChargingAmpere.value = pendingAmpere;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateServiceProvider);
    final device = useState<Device?>(null);
    final deviceLoading = useState<bool>(true);
    final fwUpdateInfo = useState<String?>(null);
    final usageListAsync =
        useState<AsyncValue<List<Usage>>>(const AsyncValue.loading());
    final scheduleListAsync =
        useState<AsyncValue<List<Schedule>>>(const AsyncValue.loading());
    final errorMessage = useState<String?>(null);
    final deviceDetailTimerRef = useRef<Timer?>(null);
    final routeAware = useRouteAwareEvent(ref.watch(routeObserverProvider));
    final lifecycle = useAppLifecycleState();
    final selectedChargingKW = useState<double>(6.0);
    final pendingChargingAmpere = useState<double?>(null);

    void handleFetchError({
      required String? message,
      required String? code,
      bool isObserved = false,
    }) {
      safeDebugPrint("[ERROR] $message, code: $code");
      try {
        errorMessage.value =
            "${AppStrings.deviceDetailFetchError}\n$message${code != null ? " ($code)" : ""}";
      } catch (e) {
        // ウィジェットがdisposeされた後のアクセスを無視
        safeDebugPrint("Failed to set errorMessage: $e");
      }
      // ネットワークエラーの場合はトースト表示(ポーリング以外)
      if (!isObserved && code == AppCustomErrors.unstableNetworkError.code) {
        BasicToast.showToast(
            AppStrings.noSignalWarningMessage, ToastType.warning);
      }
    }

    Future<void> fetchDeviceDetail(int userGroupId, {bool? isObserved}) async {
      await ref.read(deviceServiceProvider.notifier).getDeviceById(
            userGroupId: userGroupId,
            deviceId: deviceId,
            successCallback: (res) async {
              try {
                device.value = res;
                errorMessage.value = null;
                // 現在の設定値をsetting dialogで選択中にする
                if (res.chargingKw != null &&
                    selectedChargingKW.value != res.chargingKw) {
                  selectedChargingKW.value = res.chargingKw!;
                }
                // pending状態の解除処理
                await _handlePendingChargingAmpere(
                  deviceId: deviceId,
                  currentChargingAmpere: res.chargingAmpere,
                  pendingChargingAmpere: pendingChargingAmpere,
                );
              } catch (e) {
                // ウィジェットがdisposeされた後のアクセスを無視
                safeDebugPrint("Failed to update device state: $e");
              }
            },
            errorCallback: (msg, code) {
              handleFetchError(
                message: msg,
                code: code,
                isObserved: isObserved ?? false,
              );
            },
          );
    }

    // デバイスの詳細情報を30秒ごとに更新する
    void observeDeviceDetail(int userGroupId,
        {Duration duration = const Duration(seconds: 30)}) {
      deviceDetailTimerRef.value?.cancel();
      deviceDetailTimerRef.value = Timer.periodic(duration, (_) {
        fetchDeviceDetail(userGroupId, isObserved: true);
      });
    }

    Future<void> fetchUsageList(int userGroupId, String externalDeviceId,
        {int pageSize = 3}) async {
      try {
        usageListAsync.value = const AsyncValue.loading();
      } catch (e) {
        safeDebugPrint("Failed to set usageListAsync loading: $e");
      }
      await ref.read(usageServiceProvider.notifier).getUsagesByDevice(
            userGroupId: userGroupId,
            externalDeviceId: externalDeviceId,
            successCallback: (usages) {
              try {
                usageListAsync.value = AsyncValue.data(usages);
              } catch (e) {
                safeDebugPrint("Failed to set usageListAsync data: $e");
              }
            },
            errorCallback: (msg, code) {
              handleFetchError(message: msg, code: code);
            },
            pageSize: pageSize,
          );
    }

    Future<void> fetchScheduleList(int userGroupId, int deviceId) async {
      try {
        scheduleListAsync.value = const AsyncValue.loading();
      } catch (e) {
        safeDebugPrint("Failed to set scheduleListAsync loading: $e");
      }
      await ref.read(scheduleServiceProvider.notifier).getSchedulesByDevice(
            userGroupId: userGroupId,
            deviceId: deviceId,
            successCallback: (schedules) {
              try {
                scheduleListAsync.value = AsyncValue.data(schedules);
              } catch (e) {
                safeDebugPrint("Failed to set scheduleListAsync data: $e");
              }
            },
            errorCallback: (msg, code) {
              handleFetchError(message: msg, code: code);
            },
          );
    }

    Future<void> updateScheduleEnabled({
      required int userGroupId,
      required int deviceId,
      required Schedule schedule,
      required bool isEnabled,
    }) async {
      final scheduleService = ref.read(scheduleServiceProvider.notifier);
      await scheduleService.toggleScheduleEnabled(
        userGroupId: userGroupId,
        deviceId: deviceId,
        scheduleId: schedule.id,
        isEnabled: isEnabled,
        successCallback: (updatedSchedule) {
          try {
            // scheduleListのうち、更新されたスケジュールのみを変更
            final currentList = scheduleListAsync.value.value ?? [];
            final updatedList = currentList.map((s) {
              return s.id == updatedSchedule.id ? updatedSchedule : s;
            }).toList();
            scheduleListAsync.value = AsyncValue.data(updatedList);
          } catch (e) {
            safeDebugPrint("Failed to update scheduleListAsync: $e");
          }
        },
        errorCallback: (msg, code) {
          BasicDialog.showError(
              context: context, errorMessage: msg, errorCode: code);
        },
      );
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BasicScreen(
        appBar: BasicAppBar.buildPushStyleWithAction(
          context: context,
          titleAppBar: device.value?.nickname ?? '',
          subTitle: device.value?.externalDeviceId ?? '',
          onBackPressed: () => _onBack(context),
          rightIcon: IconButton(
            icon:
                Icon(Icons.settings_outlined, color: AppColors.text, size: 20),
            onPressed: () {
              context.push('/device-detail/$deviceId/settings');
            },
          ),
        ),
        body: authStateAsync.when(
          data: (authState) {
            final userGroupId = authState.defaultUserGroup?.id;

            useEffect(() {
              Future.microtask(() async {
                // 初回とフォアグラウンド復帰時
                if (lifecycle == AppLifecycleState.resumed) {
                  if (userGroupId == null) {
                    try {
                      errorMessage.value =
                          "${AppStrings.deviceListFetchError}\n"
                          "defaultUserGroupId is null";
                    } catch (e) {
                      safeDebugPrint("Failed to set errorMessage: $e");
                    }
                    return;
                  }

                  // fw_update_infoを取得（初回のみ）
                  try {
                    if (fwUpdateInfo.value == null) {
                      try {
                        final service =
                            await ref.read(fwUpdateInfoServiceProvider.future);
                        final fwInfo = await service.fetchFwUpdateInfo();
                        try {
                          fwUpdateInfo.value = fwInfo?.latestVersion;
                        } catch (e) {
                          safeDebugPrint("Failed to set fwUpdateInfo: $e");
                        }
                      } catch (e) {
                        // エラーが発生してもアプリの動作は継続
                        safeDebugPrint("Failed to fetch fw_update_info: $e");
                      }
                    }
                  } catch (e) {
                    safeDebugPrint("Failed to check fwUpdateInfo: $e");
                  }

                  await fetchDeviceDetail(userGroupId);
                  try {
                    if (device.value == null) return;
                    deviceLoading.value = false;
                    fetchUsageList(userGroupId, device.value!.externalDeviceId);
                    fetchScheduleList(userGroupId, device.value!.id);
                    observeDeviceDetail(userGroupId);
                  } catch (e) {
                    safeDebugPrint(
                        "Failed to update device state in useEffect: $e");
                  }
                } else if (lifecycle == AppLifecycleState.inactive ||
                    lifecycle == AppLifecycleState.paused) {
                  // バックグラウンドに回った場合はポーリング停止
                  deviceDetailTimerRef.value?.cancel();
                }
              });
              return () {
                deviceDetailTimerRef.value?.cancel();
              };
            }, [userGroupId, lifecycle]);

            useEffect(() {
              // 画面遷移時にポーリングの制御
              switch (routeAware) {
                case RouteAwareType.didPopNext:
                  if (userGroupId != null) {
                    // 設定画面から戻ったときなど、親が再ビルドされてfwUpdateInfoがnullになっている場合があるため再取得
                    Future.microtask(() async {
                      try {
                        final service =
                            await ref.read(fwUpdateInfoServiceProvider.future);
                        final fwInfo = await service.fetchFwUpdateInfo();
                        fwUpdateInfo.value = fwInfo?.latestVersion;
                      } catch (e) {
                        safeDebugPrint(
                            "Failed to fetch fw_update_info on didPopNext: $e");
                      }
                    });
                    fetchDeviceDetail(userGroupId);
                    observeDeviceDetail(userGroupId);
                  }
                  break;
                case RouteAwareType.didPop:
                case RouteAwareType.didPushNext:
                  // ダイアログ表示によるpushならポーリングを維持
                  if (!BasicDialog.hasOpenDialog) {
                    deviceDetailTimerRef.value?.cancel();
                  }
                  break;
                default:
                  break;
              }
              return null;
            }, [routeAware]);

            Future<void> refresh() async {
              if (userGroupId == null) {
                errorMessage.value = "${AppStrings.deviceListFetchError}\n"
                    "defaultUserGroupId is null";
                return;
              }
              await fetchDeviceDetail(userGroupId);
              if (device.value == null) return;
              fetchUsageList(userGroupId, device.value!.externalDeviceId);
              fetchScheduleList(userGroupId, device.value!.id);
            }

            // デバイス情報取得後、各セクションを個別ローディング
            return RefreshIndicator(
              onRefresh: refresh,
              child: errorMessage.value != null
                  ? ErrorMessageView(message: errorMessage.value!)
                  : Stack(
                      children: [
                        ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          children: [
                            // 充電器の情報
                            DeviceInfoSection(
                              context: context,
                              ref: ref,
                              userGroupId: userGroupId,
                              device: device,
                              pendingChargingAmpere: pendingChargingAmpere,
                              selectedChargingKW: selectedChargingKW,
                              isLoading: deviceLoading.value,
                            ),
                            const SizedBox(height: 16),
                            // 充電スケジュール
                            ScheduleSection(
                              context: context,
                              ref: ref,
                              userGroupId: userGroupId,
                              device: device,
                              scheduleListAsync: scheduleListAsync.value,
                              fetchScheduleList: fetchScheduleList,
                              updateScheduleEnabled: updateScheduleEnabled,
                              isLoading: scheduleListAsync.value.isLoading,
                            ),
                            const SizedBox(height: 16),
                            // 利用履歴タイトル＋一覧
                            UsageListSection(
                              userGroupId: userGroupId,
                              device: device,
                              usageListAsync: usageListAsync.value,
                              fetchUsageList: fetchUsageList,
                              isLoading: usageListAsync.value.isLoading,
                            ),
                          ],
                        ),
                        FirmwareUpdateWidget(
                          userGroupId: userGroupId,
                          device: device,
                          latestFwVersion: fwUpdateInfo.value,
                          isBanner: true,
                        ),
                      ],
                    ),
            );
          },
          loading: () => const SizedBox(),
          error: (e, __) {
            safeDebugPrint("Error loading home screen: $e");
            return const Text("");
          },
        ),
      ),
    );
  }
}
