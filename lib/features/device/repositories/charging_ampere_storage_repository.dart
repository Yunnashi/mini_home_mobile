import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_home/core/constants/storage_keys.dart';

class ChargingAmpereStorage {
  static const _key = StorageKeys.STORAGE_KEY_CHARGING_AMPERE;

  static Future<void> set(int deviceId, double chargingAmpere) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setDouble('$_key-$deviceId', chargingAmpere);
    await shared.setInt(
        '$_key-$deviceId-timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<Map<String, dynamic>?> getWithTimestamp(int deviceId) async {
    final shared = await SharedPreferences.getInstance();
    final ampere = shared.getDouble('$_key-$deviceId');
    final ts = shared.getInt('$_key-$deviceId-timestamp');
    if (ampere == null || ts == null) return null;
    return {'ampere': ampere, 'timestamp': ts};
  }

  static Future<void> clear(int deviceId) async {
    final shared = await SharedPreferences.getInstance();
    await Future.wait([
      shared.remove('$_key-$deviceId'),
      shared.remove('$_key-$deviceId-timestamp'),
    ]);
  }

  /// すべてのChargingAmpereStorageでセットした値を削除する
  static Future<void> clearAll() async {
    final shared = await SharedPreferences.getInstance();
    final keys = shared.getKeys();
    final ampereKeys = keys.where((k) => k.startsWith('$_key-')).toList();
    for (final k in ampereKeys) {
      await shared.remove(k);
    }
  }
}
