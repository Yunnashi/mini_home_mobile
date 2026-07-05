import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mini_home/utils/logger.dart';

part 'permission_service.g.dart';

@riverpod
class PermissionService extends _$PermissionService {
  @override
  FutureOr<PermissionStatus> build() async {
    final status = await Permission.camera.status;
    return status;
  }

  Future<PermissionStatus> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      state = AsyncData(status);
      return status;
    } catch (e) {
      safeDebugPrint(e.toString());
      return PermissionStatus.denied;
    }
  }
}
