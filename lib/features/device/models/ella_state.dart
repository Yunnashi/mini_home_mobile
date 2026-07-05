import 'package:freezed_annotation/freezed_annotation.dart';

enum EllaState {
  @JsonValue(0)
  available,
  @JsonValue(1)
  relayFailureDetected,
  @JsonValue(2)
  relayWeldingDetected,
  @JsonValue(3)
  wifiNotConnected,
  @JsonValue(4)
  highTemperatureChargingStopped,
  @JsonValue(5)
  otaInProgress,
  @JsonValue(6)
  overCurrentChargingStopped,
  @JsonValue(999)
  unknown,
}

class EllaStateConverter implements JsonConverter<EllaState, int> {
  const EllaStateConverter();

  @override
  EllaState fromJson(int json) {
    return EllaState.values.firstWhere(
      (e) => e.index == json,
      orElse: () => EllaState.unknown, // アプリで未定義でFWの仕様で先に増えた場合 unknown にマッピング
    );
  }

  @override
  int toJson(EllaState object) => object.index;
}
