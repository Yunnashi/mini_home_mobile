import 'package:freezed_annotation/freezed_annotation.dart';

enum DeviceType {
  @JsonValue('light')
  light,
  @JsonValue('airConditioner')
  airConditioner,
}
