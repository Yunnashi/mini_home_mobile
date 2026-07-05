import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mini_home/core/constants/storage_keys.dart';

class AuthStorageRepository {
  static const String _accessTokenKey =
      StorageKeys.SECURE_STORAGE_KEY_ACCESS_TOKEN;
  static const String _refreshTokenKey =
      StorageKeys.SECURE_STORAGE_KEY_REFRESH_TOKEN;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  Future<String?> getCurrentAccessToken() async {
    if (_cachedAccessToken != null) {
      return _cachedAccessToken;
    }
    _cachedAccessToken = await _storage.read(key: _accessTokenKey);
    return _cachedAccessToken;
  }

  Future<String?> getCurrentRefreshToken() async {
    if (_cachedRefreshToken != null) {
      return _cachedRefreshToken;
    }
    _cachedRefreshToken = await _storage.read(key: _refreshTokenKey);
    return _cachedRefreshToken;
  }

  Future<void> setCurrentTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);

    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
  }

  Future<void> clearCurrentTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);

    _cachedAccessToken = null;
    _cachedRefreshToken = null;
  }
}
