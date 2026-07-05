import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mini_home/features/user/repositories/user_storage_repository.dart';
import 'package:mini_home/features/user/models/user.dart';

part 'user_service.g.dart';

@riverpod
class UserService extends _$UserService {
  final UserStorageRepository _userStorageRepository = UserStorageRepository();

  User? _cachedUser;

  @override
  Future<User?> build() async {
    _cachedUser = await _userStorageRepository.getCurrentUser();
    return _cachedUser;
  }

  /// 現在のユーザーを設定する
  Future<void> setCurrentUser(User? user) async {
    await _userStorageRepository.setCurrentUser(user);
    _cachedUser = user;
    state = AsyncData(user);
  }

  /// 現在のユーザーを取得する
  Future<User?> getCurrentUser() async {
    if (_cachedUser != null) {
      return _cachedUser;
    }
    _cachedUser = await _userStorageRepository.getCurrentUser();
    return _cachedUser;
  }

  /// ユーザーデータをクリアする
  Future<void> clearCurrentUser() async {
    await _userStorageRepository.clearCurrentUser();
    _cachedUser = null;
    state = const AsyncData(null);
  }
}
