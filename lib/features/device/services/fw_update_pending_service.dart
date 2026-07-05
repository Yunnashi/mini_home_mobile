import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/models/fw_update_status.dart';
import 'package:mini_home/features/device/repositories/fw_update_requested_at_storage_repository.dart';

/// FW更新のタイムアウト時間
const Duration _kFwUpdateTimeout = Duration(minutes: 20);

enum FwPendingCheckStatus {
  none, // 未設定
  pending, // 継続中
  completed, // 完了
  timeout, // タイムアウト
}

class FwPendingCheckResult {
  final FwPendingCheckStatus status;
  final int? requestedAt; // pendingの場合のみ有効

  FwPendingCheckResult(this.status, this.requestedAt);
}

/// FWアップデートのpending状態を判定し、必要ならストレージをクリアする。
/// [cachedRequestedAt] 既に取得済みのrequestedAtを渡すことで、ストレージアクセスを省略できる
Future<FwPendingCheckResult> checkAndUpdateFwPending({
  required Device device,
  required String? latestFwVersion,
  Duration expire = _kFwUpdateTimeout,
  int? cachedRequestedAt,
}) async {
  if (latestFwVersion == null) {
    return FwPendingCheckResult(FwPendingCheckStatus.none, null);
  }

  final requestedAt =
      cachedRequestedAt ?? await FwUpdateRequestedAtStorage.get(device.id);
  if (requestedAt == null) {
    return FwPendingCheckResult(FwPendingCheckStatus.none, null);
  }

  // updating状態の場合のみ完了判定
  final status = device.fwStatus(latestFwVersion, true);
  if (status == FwUpdateStatus.updating) {
    // タイムアウト判定
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - requestedAt > expire.inMilliseconds) {
      await FwUpdateRequestedAtStorage.clear(device.id);
      return FwPendingCheckResult(FwPendingCheckStatus.timeout, null);
    }

    // 完了判定：最新バージョンになったらクリア
    final actualStatus = device.fwStatus(latestFwVersion);
    if (actualStatus == FwUpdateStatus.latest) {
      await FwUpdateRequestedAtStorage.clear(device.id);
      return FwPendingCheckResult(FwPendingCheckStatus.completed, null);
    }

    // 更新中だが完了/タイムアウトしていない場合
    return FwPendingCheckResult(FwPendingCheckStatus.pending, requestedAt);
  }

  // updating状態でない場合、タイムアウト判定のみ
  final now = DateTime.now().millisecondsSinceEpoch;
  if (now - requestedAt > expire.inMilliseconds) {
    await FwUpdateRequestedAtStorage.clear(device.id);
    return FwPendingCheckResult(FwPendingCheckStatus.timeout, null);
  }

  return FwPendingCheckResult(FwPendingCheckStatus.pending, requestedAt);
}
