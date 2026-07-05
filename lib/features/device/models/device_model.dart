import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/core/themes/images.dart';

enum DeviceModel {
  @JsonValue('LEGACY_ELLA')
  legacyElla,
  @JsonValue('ELLA')
  ella,
  @JsonValue('INDUSTRIAL')
  industrial,
  @JsonValue('NADIYA')
  nadiya;

  String getImagePath(AppImages appImages) {
    switch (this) {
      case DeviceModel.ella:
      case DeviceModel.legacyElla:
        return appImages.deviceElla;
      case DeviceModel.industrial:
        return appImages.deviceIndustrial;
      case DeviceModel.nadiya:
        return appImages.deviceNadiya;
    }
  }

  String getIconPath(AppImages appImages) {
    switch (this) {
      case DeviceModel.ella:
      case DeviceModel.legacyElla:
        return appImages.iconElla;
      case DeviceModel.industrial:
        return appImages.iconIndustrial;
      case DeviceModel.nadiya:
        return appImages.iconNadiya;
    }
  }
}
