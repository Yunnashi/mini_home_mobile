import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_dialog.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/core/widgets/basic_textfield.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/widgets/error_message_view.dart';
import 'package:mini_home/features/device/services/smart_device_service.dart';
import 'package:mini_home/features/home/services/home_service.dart';
import 'package:mini_home/router/router.dart';

class DeviceSettingScreen extends HookConsumerWidget {
  const DeviceSettingScreen({super.key, required this.deviceId});

  final int deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceAsync = ref.watch(smartDeviceServiceProvider(deviceId));
    final homeAsync = ref.watch(homeServiceProvider);
    final nameController = useTextEditingController();
    final selectedRoomId = useState<int?>(null);
    final saving = useState(false);

    useEffect(() {
      final device = deviceAsync.value;
      if (device != null && nameController.text.isEmpty) {
        nameController.text = device.name ?? device.nickname ?? '';
        selectedRoomId.value = device.roomId;
      }
      return null;
    }, [deviceAsync.value?.id]);

    Future<void> save() async {
      final roomId = selectedRoomId.value;
      final name = nameController.text.trim();
      if (roomId == null || name.isEmpty || saving.value) return;
      saving.value = true;
      try {
        await ref
            .read(smartDeviceServiceProvider(deviceId).notifier)
            .updateMetadata(name: name, roomId: roomId);
        await ref.read(homeServiceProvider.notifier).refresh();
        if (context.mounted) {
          BasicToast.showToast(AppStrings.settingsSaved, ToastType.success);
          context.pop();
        }
      } catch (_) {
        BasicToast.showToast(
            AppStrings.deviceDetailUpdateError, ToastType.error);
      } finally {
        saving.value = false;
      }
    }

    Future<void> deleteDevice() async {
      await BasicDialog.show(
        context: context,
        title: AppStrings.deleteDeviceTitle,
        content: Text(AppStrings.deleteDeviceMessage),
        buttons: [
          BasicDialogButton.cancel(),
          BasicButton.buildLarge(
            text: AppStrings.deleteDevice,
            color: AppColors.red,
            onPressed: () async {
              try {
                await ref
                    .read(smartDeviceServiceProvider(deviceId).notifier)
                    .deleteDevice();
                await ref.read(homeServiceProvider.notifier).refresh();
                if (context.mounted) context.goNamed(AppRoutes.home);
              } catch (_) {
                BasicToast.showToast(
                    AppStrings.deviceDetailUpdateError, ToastType.error);
              }
            },
          ),
        ],
      );
    }

    return BasicScreen(
      backgroundColor: AppColors.background,
      appBar: BasicAppBar.buildPushStyle(
        context: context,
        titleAppBar: AppStrings.deviceSettingsTitle,
      ),
      body: deviceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => ErrorMessageView(
          message: AppStrings.deviceDetailFetchError,
        ),
        data: (device) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            BasicTextField(
              controller: nameController,
              labelText: AppStrings.deviceName,
              borderColor: AppColors.border,
              inputFormatters: [
                LengthLimitingTextInputFormatter(24),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              initialValue: selectedRoomId.value,
              decoration: InputDecoration(
                labelText: AppStrings.room,
                filled: true,
                fillColor: AppColors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.control),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
              ),
              items: [
                for (final room in homeAsync.value?.home.rooms ?? const [])
                  DropdownMenuItem(value: room.id, child: Text(room.name)),
              ],
              onChanged: (value) => selectedRoomId.value = value,
            ),
            const SizedBox(height: AppSpacing.lg),
            BasicButton.buildLarge(
              text: AppStrings.save,
              onPressed: saving.value ? () {} : save,
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.deviceInformation,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('ID: ${device.externalDeviceId}'),
                  Text('Type: ${device.type.name}'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            BasicButton.buildLarge(
              text: AppStrings.deleteDevice,
              color: AppColors.red,
              onPressed: deleteDevice,
            ),
          ],
        ),
      ),
    );
  }
}
