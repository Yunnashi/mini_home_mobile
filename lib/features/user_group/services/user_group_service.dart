import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/user_group/models/user_group.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mini_home/features/user_group/repositories/user_group_repository.dart';

part 'user_group_service.g.dart';

@riverpod
class UserGroupService extends _$UserGroupService {
  UserGroup? _userGroup;

  @override
  UserGroup? build() {
    return _userGroup;
  }

  /// ユーザーグループ詳細を取得し、stateを更新
  Future<void> getUserGroupDetail({
    required int userGroupId,
    Function(UserGroup)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      final userGroupRepository = ref.read(userGroupRepositoryProvider);
      final response = await userGroupRepository.getUserGroupDetail(
          userGroupId: userGroupId);

      switch (response) {
        case Success(value: final data):
          final userGroup = UserGroup.fromJson(data);
          _userGroup = userGroup;
          state = userGroup;
          successCallback?.call(userGroup);

        case Failure(message: final message, code: final code):
          errorCallback?.call(message, code);
      }
    } catch (e) {
      errorCallback?.call(e.toString(), 'USER_GROUP_DETAIL_ERROR');
    }
  }
}
