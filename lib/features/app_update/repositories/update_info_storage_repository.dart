import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_home/core/constants/storage_keys.dart';

class UpdateInfoStorageRepository {
  Future<void> setLatestCancelVersionUpdateTime(String datetime) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString(StorageKeys.CANCEL_UPDATE_DATE_TIME, datetime);
  }

  Future<String?> loadLatestCancelVersionUpdateTime() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString(StorageKeys.CANCEL_UPDATE_DATE_TIME);
  }
}
