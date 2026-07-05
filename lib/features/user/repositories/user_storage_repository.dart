import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_home/core/constants/storage_keys.dart';
import 'package:mini_home/features/user/models/user.dart';

class UserStorageRepository {
  Future<void> setCurrentUser(User? user) async {
    final shared = await SharedPreferences.getInstance();
    if (user != null) {
      final userJson = user.toJson();
      await shared.setString(
          StorageKeys.USER_DEFAULTS_KEY_USER, json.encode(userJson));
    } else {
      await shared.setString(StorageKeys.USER_DEFAULTS_KEY_USER, "");
    }
  }

  Future<User?> getCurrentUser() async {
    final shared = await SharedPreferences.getInstance();
    final String user =
        shared.getString(StorageKeys.USER_DEFAULTS_KEY_USER) ?? "";
    if (user.isNotEmpty) {
      Map<String, dynamic> userMap = json.decode(user);
      return User.fromJson(userMap);
    } else {
      return null;
    }
  }

  Future<void> clearCurrentUser() async {
    final shared = await SharedPreferences.getInstance();
    await Future.wait(
        [shared.setString(StorageKeys.USER_DEFAULTS_KEY_USER, "")]);
  }
}
