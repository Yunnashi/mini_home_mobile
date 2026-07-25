import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/core/constants/api_endpoints.dart';
import 'package:mini_home/core/network/dio_client.dart';
import 'package:mini_home/core/network/models/api_request_base.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(ref.watch(dioClientProvider));
}

class HomeRepository {
  const HomeRepository(this._dioClient);

  final DioClient _dioClient;

  Future<Result> getHome(int homeId) async {
    Result? result;
    await _dioClient.sendRequest(
      resourcePath: ApiEndpoints.home(homeId),
      method: HttpMethod.get,
      isLoggedInContent: true,
      successCallback: (data) => result = Success(data),
      errorCallback: (message, code) => result = Failure(message, code: code),
    );
    return result ?? Failure('Unable to load home');
  }
}
