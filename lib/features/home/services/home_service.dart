import 'package:mini_home/core/network/models/result.dart';
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
  static const int demoHomeId = 1;

  @override
  Future<HomeDashboardState> build() => _load();

  Future<HomeDashboardState> _load() async {
    final homeResult =
        await ref.read(homeRepositoryProvider).getHome(demoHomeId);
    final devicesResult =
        await ref.read(deviceRepositoryProvider).getDevices(homeId: demoHomeId);

    if (homeResult case Success(value: final value)) {
      if (devicesResult case Success(value: final deviceData)) {
        final map = deviceData as Map<String, dynamic>;
        final devices = (map['devices'] as List<dynamic>? ?? const [])
            .map((json) => Device.fromJson(json as Map<String, dynamic>))
            .toList();
        return HomeDashboardState(
          home: Home.fromJson(value as Map<String, dynamic>),
          devices: devices,
        );
      }
    }

    final failure = homeResult is Failure ? homeResult : devicesResult;
    throw Exception(
      failure is Failure ? failure.message : 'Unable to load miniHome',
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
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
