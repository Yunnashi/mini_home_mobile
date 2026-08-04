import 'package:mini_home/core/network/models/result.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/features/device/models/device.dart';
import 'package:mini_home/features/device/repositories/device_repository.dart';
import 'package:mini_home/features/home/models/home.dart';
import 'package:mini_home/features/home/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_service.g.dart';

class HomeDashboardState {
  const HomeDashboardState({
    required this.home,
    required this.devices,
    this.selectedRoomId,
  });

  final Home home;
  final List<Device> devices;
  final int? selectedRoomId;

  List<Device> get visibleDevices => selectedRoomId == null
      ? devices
      : devices.where((device) => device.roomId == selectedRoomId).toList();

  HomeDashboardState copyWith({
    Home? home,
    List<Device>? devices,
    int? selectedRoomId,
    bool clearSelectedRoom = false,
  }) {
    return HomeDashboardState(
      home: home ?? this.home,
      devices: devices ?? this.devices,
      selectedRoomId:
          clearSelectedRoom ? null : selectedRoomId ?? this.selectedRoomId,
    );
  }
}

@Riverpod(keepAlive: true)
class HomeService extends _$HomeService {
  @override
  Future<HomeDashboardState> build() async {
    final authState = await ref.watch(authStateServiceProvider.future);
    final homeId = authState.defaultHomeId;
    if (homeId == null) {
      throw Exception('Default home is not configured');
    }
    return _load(homeId);
  }

  Future<HomeDashboardState> _load(int homeId) async {
    final homeResult = await ref.read(homeRepositoryProvider).getHome(homeId);
    final devicesResult =
        await ref.read(deviceRepositoryProvider).getDevices(homeId: homeId);

    if (homeResult case Success(value: final value)) {
      if (devicesResult case Success(value: final deviceData)) {
        final homeMap = value as Map<String, dynamic>;
        final map = deviceData as Map<String, dynamic>;
        final devices = (map['devices'] as List<dynamic>? ?? const [])
            .map((json) => Device.fromJson(json as Map<String, dynamic>))
            .toList();
        return HomeDashboardState(
          home: Home.fromJson(homeMap),
          devices: devices,
        );
      }
    }

    final failure = homeResult is Failure ? homeResult : devicesResult;
    throw Exception(
      failure is Failure ? failure.message : 'Unable to load miniHome',
    );
  }

  Future<void> refresh({bool showLoading = true}) async {
    final previous = state;
    if (showLoading) {
      state = const AsyncLoading();
    }
    final authState = await ref.read(authStateServiceProvider.future);
    final homeId = authState.defaultHomeId;
    final next = await AsyncValue.guard(() async {
      if (homeId == null) {
        throw Exception('Default home is not configured');
      }
      return _load(homeId);
    });
    if (!showLoading && next.hasError && previous.hasValue) {
      return;
    }
    state = next;
  }

  void selectRoom(int? roomId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      roomId == null
          ? current.copyWith(clearSelectedRoom: true)
          : current.copyWith(selectedRoomId: roomId),
    );
  }

  Future<void> togglePower(Device device, bool value) async {
    final current = state.value;
    if (current == null || !device.isOnline) return;
    final original = current.devices;
    state = AsyncData(current.copyWith(
      devices: [
        for (final item in original)
          if (item.id == device.id) item.copyWith(isPowerOn: value) else item,
      ],
    ));

    final result = await ref.read(deviceRepositoryProvider).updatePower(
          homeId: current.home.id,
          deviceId: device.id,
          isPowerOn: value,
        );
    if (result is Failure) {
      state = AsyncData(current.copyWith(devices: original));
      throw Exception(result.message);
    }
  }
}
