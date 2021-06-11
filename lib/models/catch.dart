import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'catch.jser.dart';

@GenSerializer(
  serializers: [],
  fields: {
    'catchType': EnDecode(alias: 'catch_type'),
    'catchReportID': EnDecode(alias: 'catch_report_id'),
    'numberOfFish': EnDecode(alias: 'num_of_fish'),
    'typeOfFish': EnDecode(alias: 'type_of_fish'),
    'weatherCondition': EnDecode(alias: 'weather_condition'),
    'windDirection': EnDecode(alias: 'wind_direction'),
    'userID': EnDecode(alias: 'user_id'),
  },
)

class CatchJSONSerializer extends Serializer<Catch>
    with _$CatchJSONSerializer {}

class Catch {
  Catch({
    this.userID,
    this.catchType,
    this.catchReportID,
    this.date,
    this.notes,
    this.numberOfFish,
    this.position,
    this.temperature,
    this.time,
    this.typeOfFish,
    this.weatherCondition,
    this.weight,
    this.windDirection,
    this.images,
  });

  String userID;
  String catchType;
  String catchReportID;
  String date;
  String notes;
  int numberOfFish;
  int position;
  double temperature;
  String time;
  String typeOfFish;
  String weatherCondition;
  double weight;
  String windDirection;
  List<String> images;
}
