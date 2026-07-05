import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/core/constants/api_endpoints.dart';
import 'package:mini_home/core/network/dio_client.dart';
import 'package:mini_home/core/network/models/api_request_base.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usage_repository.g.dart';

@riverpod
UsageRepository usageRepository(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UsageRepository._(dioClient);
}

class UsageRepository {
  final DioClient _dioClient;

  UsageRepository._(this._dioClient);

  Future<Result> getUsages({
    required int userGroupId,
    required String externalDeviceId,
    int pageSize = 3,
    int pageNum = 1,
    bool isFinalized = true,
    String sortOrder = 'desc',
  }) async {
    Result? response;
    final queryParams = {
      'page_size': pageSize,
      'page_num': pageNum,
      'device_id': externalDeviceId,
      'is_finalized': isFinalized,
      'sort_order': sortOrder,
    };
    await _dioClient.sendRequest(
      resourcePath: '${ApiEndpoints.userGroups}/$userGroupId/usages',
      method: HttpMethod.get,
      isLoggedInContent: true,
      queryParameters: queryParams,
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }
}
