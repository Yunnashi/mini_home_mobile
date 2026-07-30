import 'package:freezed_annotation/freezed_annotation.dart';

enum DeviceModel {
  @JsonValue('LEGACY_ELLA')
  legacyElla,
  @JsonValue('ELLA')
  ella,
  @JsonValue('INDUSTRIAL')
  industrial,
  @JsonValue('NADIYA')
  nadiya;
}
