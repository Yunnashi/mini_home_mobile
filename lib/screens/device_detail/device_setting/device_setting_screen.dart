import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_toast.dart';
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
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppStrings.deleteDeviceTitle),
          content: Text(AppStrings.deleteDeviceMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppStrings.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppStrings.deleteDevice),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
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
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.deviceSettingsTitle)),
      body: deviceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (device) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: AppStrings.deviceName),
              maxLength: 24,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              value: selectedRoomId.value,
              decoration: InputDecoration(labelText: AppStrings.room),
              items: [
                for (final room in homeAsync.value?.home.rooms ?? const [])
                  DropdownMenuItem(value: room.id, child: Text(room.name)),
              ],
              onChanged: (value) => selectedRoomId.value = value,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: saving.value ? null : save,
              child: saving.value
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(AppStrings.save),
            ),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
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
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: deleteDevice,
              icon: const Icon(Icons.delete_outline),
              label: Text(AppStrings.deleteDevice),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.red),
            ),
          ],
        ),
      ),
    );
  }
}
