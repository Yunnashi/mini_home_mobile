import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_summary.freezed.dart';
part 'home_summary.g.dart';

@freezed
abstract class HomeSummary with _$HomeSummary {
  const factory HomeSummary({
    int? activeDeviceCount,
    int? indoorTemperature,
    double? todayEnergyKwh,
  }) = _HomeSummary;

  factory HomeSummary.fromJson(Map<String, dynamic> json) =>
      _$HomeSummaryFromJson(json);
}
