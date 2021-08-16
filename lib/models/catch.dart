import 'package:json_annotation/json_annotation.dart';
// part 'catch.g.dart';

@JsonSerializable()
class Catch {
  Catch({
    required this.id,
    required this.catchReportID,
    required this.catchType,
    this.date,
    this.images,
    this.notes,
    this.numberOfFish,
    this.position,
    this.temperature,
    this.time,
    this.typeOfFish,
    required this.userID,
    this.weatherCondition,
    this.weight,
    this.windDirection,
  });

  String id;

  @JsonKey(name: 'catch_report_id')
  String catchReportID;

  @JsonKey(name: 'catch_type')
  String catchType;

  String? date;
  List<String>? images;
  String? notes;

  @JsonKey(name: 'num_of_fish')
  int? numberOfFish;

  int? position;
  double? temperature;
  String? time;

  @JsonKey(name: 'type_of_fish')
  String? typeOfFish;

  @JsonKey(name: 'user_id')
  String userID;

  @JsonKey(name: 'weather_condition')
  String? weatherCondition;

  @JsonKey(name: 'wind_direction')
  String? windDirection;

  double? weight;

  // factory Catch.fromJson(Map<String, dynamic> json) => _$CatchFromJson(json);
  // Map<String, dynamic> toJson() => _$CatchToJson(this);
}
