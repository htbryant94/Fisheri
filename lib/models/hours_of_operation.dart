import 'package:json_annotation/json_annotation.dart';
part 'hours_of_operation.g.dart';

@JsonSerializable(explicitToJson: true)
class HoursOfOperation {
  HoursOfOperation({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  OpeningHoursDay? monday;
  OpeningHoursDay? tuesday;
  OpeningHoursDay? wednesday;
  OpeningHoursDay? thursday;
  OpeningHoursDay? friday;
  OpeningHoursDay? saturday;
  OpeningHoursDay? sunday;

  factory HoursOfOperation.fromJson(Map<String, dynamic> json) => _$HoursOfOperationFromJson(json);
  Map<String, dynamic> toJson() => _$HoursOfOperationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OpeningHoursDay {
  OpeningHoursDay({
    this.open,
    this.close,
  });

  String? open;
  String? close;

  factory OpeningHoursDay.fromJson(Map<String, dynamic> json) => _$OpeningHoursDayFromJson(json);
  Map<String, dynamic> toJson() => _$OpeningHoursDayToJson(this);
}
