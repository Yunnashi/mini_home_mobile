import 'package:freezed_annotation/freezed_annotation.dart';

part 'air_conditioner_state.freezed.dart';
part 'air_conditioner_state.g.dart';

enum AirConditionerMode {
  auto,
  cooling,
  heating,
  fan,
}

enum FanSpeed {
  auto,
  low,
  medium,
  high,
}

@freezed
abstract class AirConditionerState with _$AirConditionerState {
  const factory AirConditionerState({
    @Default(24) int targetTemperature,
    @Default(AirConditionerMode.auto) AirConditionerMode mode,
    @Default(FanSpeed.auto) FanSpeed fanSpeed,
  }) = _AirConditionerState;

  factory AirConditionerState.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerStateFromJson(json);
}
