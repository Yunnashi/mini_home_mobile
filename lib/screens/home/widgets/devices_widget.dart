import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/constants/custom_errors.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/screens/home/widgets/device_card.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/features/user_group/models/user_group.dart';
import 'package:mini_home/features/user_group/services/user_group_service.dart';
import 'package:mini_home/router/app_route_observer.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/screens/home/widgets/no_device_widget.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:mini_home/utils/route_aware_event.dart';

class DevicesWidget extends HookConsumerWidget {
  final AuthState authState;
  final Function(Widget?)? onLeftWidgetChanged;

  const DevicesWidget(
    this.authState, {
    super.key,
    this.onLeftWidgetChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGroup = ref.watch(userGroupServiceProvider);
    final errorMessage = useState<String?>(null);
    final devicesTimerRef = useRef<Timer?>(null);
    final routeAware = useRouteAwareEvent(ref.watch(routeObserverProvider));
    final lifecycle = useAppLifecycleState();
    final isLoading = useState<bool>(true);

    Future<void> fetchUserGroupDevices(UserGroup? defaultUserGroup,
        {bool? isObserved}) async {
      final userGroupId = defaultUserGroup?.id;
      if (userGroupId == null) {
        errorMessage.value =
            "${AppStrings.deviceListFetchError}\n defaultUserGroupId is null";
        return;
      }
      await ref.read(userGroupServiceProvider.notifier).getUserGroupDetail(
            userGroupId: userGroupId,
            successCallback: (userGroup) {
              errorMessage.value = null;
            },
            errorCallback: (msg, code) {
              safeDebugPrint("[ERROR] $msg, code: $code");
              if (isLoading.value) {
                errorMessage.value =
                    "${AppStrings.deviceListFetchError}\n$msg${code != null ? " ($code)" : ""}";
              } else {
                // ネットワークエラーの場合はトースト表示(ポーリング以外)
                if (isObserved != true &&
                    code == AppCustomErrors.unstableNetworkError.code) {
                  BasicToast.showToast(
                      AppStrings.noSignalWarningMessage, ToastType.warning);
                }
              }
            },
          );
    }

    // デバイスの一覧情報を30秒ごとに更新する
    void observeDeviceList(UserGroup? userGroup,
        {Duration duration = const Duration(seconds: 30)}) {
      devicesTimerRef.value?.cancel();
      devicesTimerRef.value = Timer.periodic(duration, (_) {
        fetchUserGroupDevices(userGroup, isObserved: true);
      });
    }

    Future<void> refresh() async {
      await fetchUserGroupDevices(authState.defaultUserGroup);
    }

    Widget buildHeader() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.home_outlined, color: AppColors.text, size: 24),
            const SizedBox(width: 8),
            Text(
              (userGroup?.name != null && userGroup!.name!.isNotEmpty)
                  ? userGroup.name!
                  : AppStrings.myHome,
              style: AppTextStyle.heading2,
            ),
          ],
        ),
      );
    }

    useEffect(() {
      Future.microtask(() async {
        // 初回とフォアグラウンド復帰時
        if (lifecycle == AppLifecycleState.resumed) {
          await fetchUserGroupDevices(authState.defaultUserGroup);
          isLoading.value = false;
          observeDeviceList(authState.defaultUserGroup);
        } else if (lifecycle == AppLifecycleState.inactive ||
            lifecycle == AppLifecycleState.paused) {
          // バックグラウンドに回った場合はポーリング停止
          devicesTimerRef.value?.cancel();
        }
      });
      return () {
        devicesTimerRef.value?.cancel();
      };
    }, [authState.defaultUserGroup?.id, lifecycle]);

    useEffect(() {
      // 画面遷移時にポーリングの制御
      switch (routeAware) {
        case RouteAwareType.didPopNext:
          if (userGroup?.id != null) {
            fetchUserGroupDevices(userGroup);
            observeDeviceList(userGroup);
          }
          break;
        case RouteAwareType.didPop:
        case RouteAwareType.didPushNext:
          devicesTimerRef.value?.cancel();
          break;
        default:
          break;
      }
      return null;
    }, [routeAware]);

    useEffect(() {
      // AppBarのleftWidgetを更新
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (onLeftWidgetChanged != null) {
          if (errorMessage.value != null) {
            onLeftWidgetChanged!(null);
          } else {
            // Group名を表示
            onLeftWidgetChanged!(buildHeader());
          }
        }
      });
      return null;
    }, [errorMessage.value, userGroup?.name]);

    final devices = userGroup?.devices ?? [];
    final isNoDevice = devices.isEmpty && authState.isLoggedIn;

    return RefreshIndicator(
      onRefresh: refresh,
      child: isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.grey))
          : errorMessage.value != null
              ? ErrorMessageView(message: errorMessage.value!)
              : isNoDevice
                  ? Column(
                      children: [
                        Expanded(child: NoDeviceWidget(authState)),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 32.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: 1 + devices.length, // add cardで1つ追加
                      itemBuilder: (context, index) {
                        // デバイスリスト
                        if (index < devices.length) {
                          final device = devices[index];
                          return DeviceCard(
                            device: device,
                            // pendingChargingAmpere: あとで,
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.deviceDetail,
                                pathParameters: {
                                  'deviceId': device.id.toString()
                                },
                              );
                            },
                          );
                        }

                        // 追加カード
                        if (index == devices.length && devices.isNotEmpty) {
                          return _addCard(onTap: () {
                            context.pushNamed(AppRoutes.deviceRegistration,
                                extra: authState);
                          });
                        }

                        return const SizedBox.shrink();
                      }),
    );
  }

  Widget _addCard({required VoidCallback onTap}) {
    final double borderRadius = 5.51;
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: [2, 2],
        radius: Radius.circular(borderRadius),
        color: AppColors.border,
        padding: const EdgeInsets.all(1),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: AppColors.greyText,
                  size: 40,
                ),
                Text(
                  AppStrings.addDevice,
                  style: AppTextStyle.body2TextGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
