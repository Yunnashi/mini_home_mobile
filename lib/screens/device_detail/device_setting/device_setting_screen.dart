import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/core/widgets/device_reboot_widget.dart';
import 'package:mini_home/core/widgets/fw_update_section.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/services/device_service.dart';
import 'package:mini_home/features/device/services/fw_update_info_service.dart';
import 'package:mini_home/screens/device_detail/dialogs/nickname_edit_dialog.dart';
import 'package:mini_home/utils/logger.dart';
import 'package:mini_home/utils/route_aware_event.dart';
import 'package:mini_home/router/app_route_observer.dart';

final BoxDecoration _kDeviceSettingSectionDecoration = BoxDecoration(
  color: AppColors.white,
  border: Border.all(
    color: AppColors.border,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(10),
);

const double _kSectionDividerMargin = 16;

class DeviceSettingScreen extends HookConsumerWidget {
  const DeviceSettingScreen({super.key, required this.deviceId});
  final int deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateServiceProvider);
    final device = useMemoized(() => ValueNotifier<Device?>(null));
    final deviceLoading = useState(true);
    final errorMessage = useState<String?>(null);
    final fwUpdateInfo = useState<String?>(null);
    final settingTimerRef = useRef<Timer?>(null);
    final lifecycle = useAppLifecycleState();
    final routeAware = useRouteAwareEvent(ref.watch(routeObserverProvider));

    Future<void> fetchDevice(int userGroupId, {bool isObserved = false}) async {
      await ref.read(deviceServiceProvider.notifier).getDeviceById(
            userGroupId: userGroupId,
            deviceId: deviceId,
            successCallback: (res) {
              device.value = res;
              errorMessage.value = null;
            },
            errorCallback: (msg, code) {
              if (!isObserved) {
                safeDebugPrint("[ERROR] $msg, code: $code");
                errorMessage.value = msg;
              }
            },
          );
    }

    void observeDevice(int userGroupId,
        {Duration duration = const Duration(seconds: 30)}) {
      settingTimerRef.value?.cancel();
      settingTimerRef.value = Timer.periodic(duration, (_) {
        fetchDevice(userGroupId, isObserved: true);
      });
    }

    return BasicScreen(
      appBar: BasicAppBar.buildPushStyle(
        context: context,
        titleAppBar: AppStrings.deviceSettingsTitle,
        onBackPressed: () => context.pop(),
      ),
      body: authStateAsync.when(
        data: (authState) {
          final userGroupId = authState.defaultUserGroup?.id;

          useEffect(() {
            if (userGroupId == null) return null;
            Future.microtask(() async {
              if (fwUpdateInfo.value == null) {
                try {
                  final service =
                      await ref.read(fwUpdateInfoServiceProvider.future);
                  final fwInfo = await service.fetchFwUpdateInfo();
                  fwUpdateInfo.value = fwInfo?.latestVersion;
                } catch (e) {
                  safeDebugPrint("Failed to fetch fw_update_info: $e");
                }
              }
              await fetchDevice(userGroupId);
              deviceLoading.value = false;
              observeDevice(userGroupId);
            });
            return () {
              settingTimerRef.value?.cancel();
            };
          }, [userGroupId]);

          useEffect(() {
            if (userGroupId == null) return null;
            if (lifecycle == AppLifecycleState.resumed) {
              fetchDevice(userGroupId, isObserved: true);
              observeDevice(userGroupId);
            } else if (lifecycle == AppLifecycleState.inactive ||
                lifecycle == AppLifecycleState.paused) {
              settingTimerRef.value?.cancel();
            }
            return null;
          }, [lifecycle, userGroupId]);

          useEffect(() {
            if (userGroupId == null) return null;
            switch (routeAware) {
              case RouteAwareType.didPopNext:
                fetchDevice(userGroupId, isObserved: true);
                observeDevice(userGroupId);
                break;
              case RouteAwareType.didPop:
              case RouteAwareType.didPushNext:
                settingTimerRef.value?.cancel();
                break;
              default:
                break;
            }
            return null;
          }, [routeAware, userGroupId]);

          if (errorMessage.value != null) {
            return ErrorMessageView(message: errorMessage.value!);
          }

          if (deviceLoading.value || device.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentDevice = device.value!;

          return ColoredBox(
            color: AppColors.background,
            child: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    CupertinoListSection.insetGrouped(
                      margin: EdgeInsets.zero,
                      dividerMargin: 0,
                      additionalDividerMargin: _kSectionDividerMargin,
                      decoration: _kDeviceSettingSectionDecoration,
                      children: [
                        CupertinoListTile(
                          title: Text(
                            AppStrings.deviceNicknameShort,
                            style: AppTextStyle.body2,
                          ),
                          trailing: LayoutBuilder(
                            builder: (context, constraints) {
                              final width =
                                  (MediaQuery.sizeOf(context).width * 0.7)
                                      .clamp(120.0, 260.0);
                              return SizedBox(
                                width: width,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        currentDevice.nickname ?? '',
                                        style: AppTextStyle.body2.copyWith(
                                          color: AppColors.grey,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      CupertinoIcons.chevron_forward,
                                      size: 20,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            showNicknameEditDialog(
                              context: context,
                              nickname: currentDevice.nickname ?? '',
                              onSave: (nickname) async {
                                if (userGroupId == null) return;
                                await ref
                                    .read(deviceServiceProvider.notifier)
                                    .updateNickname(
                                      userGroupId: userGroupId,
                                      deviceId: deviceId,
                                      nickname: nickname,
                                      successCallback: (value) async {
                                        if (context.mounted) {
                                          await fetchDevice(userGroupId);
                                          if (context.mounted) {
                                            context.pop();
                                          }
                                        }
                                      },
                                      errorCallback: (msg, code) {
                                        BasicDialog.showError(
                                          context: context,
                                          errorMessage: msg,
                                          errorCode: code,
                                        );
                                      },
                                    );
                              },
                            );
                          },
                        ),
                        CupertinoListTile(
                          title: Text(
                            AppStrings.deviceId,
                            style: AppTextStyle.body2,
                          ),
                          trailing: Text(
                            currentDevice.externalDeviceId,
                            style: AppTextStyle.body2.copyWith(
                              color: AppColors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CupertinoListSection.insetGrouped(
                      margin: EdgeInsets.zero,
                      dividerMargin: _kSectionDividerMargin,
                      decoration: _kDeviceSettingSectionDecoration,
                      children: [
                        CupertinoListTile(
                          title: Text(
                            AppStrings.deviceFwVersionLabel,
                            style: AppTextStyle.body2,
                          ),
                          trailing: LayoutBuilder(
                            builder: (context, constraints) {
                              final width =
                                  (MediaQuery.sizeOf(context).width * 0.7)
                                      .clamp(120.0, 220.0);
                              return SizedBox(
                                width: width,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FirmwareUpdateWidget(
                                    userGroupId: userGroupId,
                                    device: device,
                                    latestFwVersion: fwUpdateInfo.value,
                                    isBanner: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (userGroupId != null && currentDevice.isRebootable) ...[
                      const SizedBox(height: 24),
                      CupertinoListSection.insetGrouped(
                        margin: EdgeInsets.zero,
                        dividerMargin: _kSectionDividerMargin,
                        decoration: _kDeviceSettingSectionDecoration,
                        children: [
                          CupertinoListTile(
                            title: Text(
                              AppStrings.deviceSettingRebootLabel,
                              style: AppTextStyle.body2,
                            ),
                            trailing: SizedBox(
                              width: 200,
                              child: DeviceRebootWidget(
                                userGroupId: userGroupId,
                                deviceId: deviceId,
                                externalDeviceId:
                                    currentDevice.externalDeviceId,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorMessageView(message: e.toString()),
      ),
    );
  }
}
