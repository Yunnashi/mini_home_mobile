import 'package:mini_home/core/network/models/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mini_home/features/usage/repositories/usage_repository.dart';
import 'package:mini_home/features/usage/models/usage.dart';

part 'usage_service.g.dart';

@riverpod
class UsageService extends _$UsageService {
  @override
  void build() {}

  Future<void> getUsagesByDevice({
    required int homeId,
    required int deviceId,
    required String externalDeviceId,
    int pageSize = 3,
    int pageNum = 1,
    Function(List<Usage>)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      final usageRepository = ref.read(usageRepositoryProvider);
      final response = await usageRepository.getUsages(
        homeId: homeId,
        deviceId: deviceId,
        externalDeviceId: externalDeviceId,
        pageSize: pageSize,
        pageNum: pageNum,
      );
      if (response is Success) {
        final data = response.value is Map<String, dynamic> &&
                response.value['data'] is List
            ? response.value['data'] as List
            : [];
        final usages = data
            .map<Usage>((json) => Usage.fromJson(json as Map<String, dynamic>))
            .toList();
        successCallback?.call(usages);
      } else if (response is Failure) {
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      errorCallback?.call(e.toString(), 'USAGE_LIST_ERROR');
    }
  }
}
