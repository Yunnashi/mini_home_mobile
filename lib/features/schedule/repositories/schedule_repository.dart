import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_home/core/constants/api_endpoints.dart';
import 'package:mini_home/core/network/dio_client.dart';
import 'package:mini_home/core/network/models/api_request_base.dart';
import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_repository.g.dart';

@riverpod
ScheduleRepository scheduleRepository(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ScheduleRepository._(dioClient);
}

class ScheduleRepository {
  final DioClient _dioClient;

  ScheduleRepository._(this._dioClient);

  Future<Result> getSchedules({
    required int userGroupId,
    required int deviceId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/schedules',
      method: HttpMethod.get,
      isLoggedInContent: true,
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> createSchedule({
    required int userGroupId,
    required int deviceId,
    required String startAt,
    required String finishAt,
    required List<Weekday> weekdays,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/schedules',
      method: HttpMethod.post,
      isLoggedInContent: true,
      body: {
        'startAt': startAt,
        'finishAt': finishAt,
        'weekdays': weekdays.map((w) => w.name.toUpperCase()).toList()
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> updateSchedule({
    required int userGroupId,
    required int deviceId,
    required String scheduleId,
    required String startAt,
    required String finishAt,
    required List<Weekday> weekdays,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/schedules/$scheduleId',
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {
        'startAt': startAt,
        'finishAt': finishAt,
        'weekdays': weekdays.map((w) => w.name.toUpperCase()).toList()
      },
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> toggleScheduleEnabled({
    required int userGroupId,
    required int deviceId,
    required String scheduleId,
    required bool isEnabled,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/schedules/$scheduleId/enabled',
      method: HttpMethod.patch,
      isLoggedInContent: true,
      body: {'isEnabled': isEnabled},
      successCallback: (data) {
        response = Success(data);
      },
      errorCallback: (message, code) {
        response = Failure(message, code: code);
      },
    );
    return response ?? Failure('Unknown error');
  }

  Future<Result> deleteSchedule({
    required int userGroupId,
    required int deviceId,
    required String scheduleId,
  }) async {
    Result? response;
    await _dioClient.sendRequest(
      resourcePath:
          '${ApiEndpoints.userGroups}/$userGroupId/devices/$deviceId/schedules/$scheduleId',
      method: HttpMethod.delete,
      isLoggedInContent: true,
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
