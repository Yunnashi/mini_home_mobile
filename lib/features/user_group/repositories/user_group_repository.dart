import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/core/constants/api_endpoints.dart';
import 'package:mini_home/core/network/dio_client.dart';
import 'package:mini_home/core/network/models/api_request_base.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_group_repository.g.dart';

@riverpod
UserGroupRepository userGroupRepository(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UserGroupRepository._(dioClient);
}

class UserGroupRepository {
  final DioClient _dioClient;

  UserGroupRepository._(this._dioClient);

  Future<Result> getUserGroupDetail({
    required int userGroupId,
  }) async {
    Result? response;

    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.userGroups}/$userGroupId',
      method: HttpMethod.get,
      isLoggedInContent: true,
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(
          message,
          code: code,
        );
      },
    );

    return response ?? Failure('Unknown error');
  }
}
