import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_home/core/constants/storage_keys.dart';

class FwUpdateRequestedAtStorage {
  static const _key = StorageKeys.STORAGE_KEY_FW_UPDATE_REQUESTED_AT;

  static Future<void> set(int deviceId) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setInt(
        '$_key-$deviceId', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<void> setWithTimestamp(int deviceId, int timestamp) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setInt('$_key-$deviceId', timestamp);
  }

  static Future<int?> get(int deviceId) async {
    final shared = await SharedPreferences.getInstance();
    return shared.getInt('$_key-$deviceId');
  }

  static Future<void> clear(int deviceId) async {
    final shared = await SharedPreferences.getInstance();
    await Future.wait([
      shared.remove('$_key-$deviceId'),
    ]);
  }

  /// すべてのFW update requested atでセットした値を削除する
  static Future<void> clearAll() async {
    final shared = await SharedPreferences.getInstance();
    final keys = shared.getKeys();
    final requestedAtKeys = keys.where((k) => k.startsWith('$_key-')).toList();
    for (final k in requestedAtKeys) {
      await shared.remove(k);
    }
  }
}
