import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/features/home/models/home_summary.dart';
import 'package:mini_home/features/home/models/room.dart';

part 'home.freezed.dart';
part 'home.g.dart';

@freezed
abstract class Home with _$Home {
  const factory Home({
    required int id,
    required String name,
    HomeSummary? summary,
    @Default(<Room>[]) List<Room> rooms,
  }) = _Home;

  factory Home.fromJson(Map<String, dynamic> json) => _$HomeFromJson(json);
}
