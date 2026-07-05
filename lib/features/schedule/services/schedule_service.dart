import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/utils/loading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mini_home/features/schedule/repositories/schedule_repository.dart';
import 'package:mini_home/features/schedule/models/schedule.dart';

part 'schedule_service.g.dart';

@riverpod
class ScheduleService extends _$ScheduleService {
  @override
  void build() {}

  Future<void> getSchedulesByDevice({
    required int userGroupId,
    required int deviceId,
    Function(List<Schedule>)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      final scheduleRepository = ref.read(scheduleRepositoryProvider);
      final response = await scheduleRepository.getSchedules(
        userGroupId: userGroupId,
        deviceId: deviceId,
      );
      if (response is Success) {
        // APIからのレスポンスが配列形式であることを想定
        final data = response.value is List ? response.value as List : [];
        final schedules = data
            .map<Schedule>(
                (json) => Schedule.fromJson(json as Map<String, dynamic>))
            .toList();
        successCallback?.call(schedules);
      } else if (response is Failure) {
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      errorCallback?.call(e.toString(), 'SCHEDULE_LIST_ERROR');
    }
  }

  Future<void> createSchedule({
    required int userGroupId,
    required int deviceId,
    required Schedule schedule,
    Function(Schedule)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final scheduleRepository = ref.read(scheduleRepositoryProvider);

      final response = await scheduleRepository.createSchedule(
          userGroupId: userGroupId,
          deviceId: deviceId,
          startAt: schedule.startAt,
          finishAt: schedule.finishAt,
          weekdays: schedule.weekdays);

      if (response is Success) {
        final createdSchedule =
            Schedule.fromJson(response.value as Map<String, dynamic>);
        Loading().dismiss();
        successCallback?.call(createdSchedule);
      } else if (response is Failure) {
        Loading().dismiss();
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'SCHEDULE_CREATE_ERROR');
    }
  }

  Future<void> updateSchedule({
    required int userGroupId,
    required int deviceId,
    required Schedule schedule,
    Function(Schedule)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final scheduleRepository = ref.read(scheduleRepositoryProvider);

      final response = await scheduleRepository.updateSchedule(
          userGroupId: userGroupId,
          deviceId: deviceId,
          scheduleId: schedule.id,
          startAt: schedule.startAt,
          finishAt: schedule.finishAt,
          weekdays: schedule.weekdays);

      if (response is Success) {
        final updatedSchedule =
            Schedule.fromJson(response.value as Map<String, dynamic>);
        Loading().dismiss();
        successCallback?.call(updatedSchedule);
      } else if (response is Failure) {
        Loading().dismiss();
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'SCHEDULE_UPDATE_ERROR');
    }
  }

  Future<void> toggleScheduleEnabled({
    required int userGroupId,
    required int deviceId,
    required String scheduleId,
    required bool isEnabled,
    Function(Schedule)? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final scheduleRepository = ref.read(scheduleRepositoryProvider);

      final response = await scheduleRepository.toggleScheduleEnabled(
        userGroupId: userGroupId,
        deviceId: deviceId,
        scheduleId: scheduleId,
        isEnabled: isEnabled,
      );

      if (response is Success) {
        final updatedSchedule =
            Schedule.fromJson(response.value as Map<String, dynamic>);
        Loading().dismiss();
        successCallback?.call(updatedSchedule);
      } else if (response is Failure) {
        Loading().dismiss();
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'SCHEDULE_ENABLED_TOGGLE_ERROR');
    }
  }

  Future<void> deleteSchedule({
    required int userGroupId,
    required int deviceId,
    required String scheduleId,
    Function()? successCallback,
    Function(String?, String?)? errorCallback,
  }) async {
    try {
      Loading().show();
      final scheduleRepository = ref.read(scheduleRepositoryProvider);

      final response = await scheduleRepository.deleteSchedule(
        userGroupId: userGroupId,
        deviceId: deviceId,
        scheduleId: scheduleId,
      );

      if (response is Success) {
        Loading().dismiss();
        successCallback?.call();
      } else if (response is Failure) {
        Loading().dismiss();
        errorCallback?.call(response.message, response.code);
      }
    } catch (e) {
      Loading().dismiss();
      errorCallback?.call(e.toString(), 'SCHEDULE_DELETE_ERROR');
    }
  }
}
