import 'package:freezed_annotation/freezed_annotation.dart';

part 'light_state.freezed.dart';
part 'light_state.g.dart';

@freezed
abstract class LightState with _$LightState {
  const factory LightState({
    @Default(50) int brightness,
    @Default(4000) int colorTemperature,
  }) = _LightState;

  factory LightState.fromJson(Map<String, dynamic> json) =>
      _$LightStateFromJson(json);
}
