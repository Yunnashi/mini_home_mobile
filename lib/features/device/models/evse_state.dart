import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum EvseState {
  @JsonValue(0)
  disconnected,
  @JsonValue(1)
  connected,
  @JsonValue(2)
  charging1,
  @JsonValue(3)
  charging2,
  @JsonValue(4)
  error1,
  @JsonValue(5)
  error2,
  @JsonValue(6)
  error3,
  @JsonValue(999)
  unknown,
}

class EvseStateConverter implements JsonConverter<EvseState, int> {
  const EvseStateConverter();

  @override
  EvseState fromJson(int json) {
    return EvseState.values.firstWhere(
      (e) => e.index == json,
      orElse: () => EvseState.unknown, // アプリで未定義でFWの仕様で先に増えた場合 unknown にマッピング
    );
  }

  @override
  int toJson(EvseState object) => object.index;
}
