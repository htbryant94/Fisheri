// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hours_of_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoursOfOperation _$HoursOfOperationFromJson(Map<String, dynamic> json) {
  return HoursOfOperation(
    monday: json['monday'] == null
        ? null
        : OpeningHoursDay.fromJson(json['monday'] as Map<String, dynamic>),
    tuesday: json['tuesday'] == null
        ? null
        : OpeningHoursDay.fromJson(json['tuesday'] as Map<String, dynamic>),
    wednesday: json['wednesday'] == null
        ? null
        : OpeningHoursDay.fromJson(json['wednesday'] as Map<String, dynamic>),
    thursday: json['thursday'] == null
        ? null
        : OpeningHoursDay.fromJson(json['thursday'] as Map<String, dynamic>),
    friday: json['friday'] == null
        ? null
        : OpeningHoursDay.fromJson(json['friday'] as Map<String, dynamic>),
    saturday: json['saturday'] == null
        ? null
        : OpeningHoursDay.fromJson(json['saturday'] as Map<String, dynamic>),
    sunday: json['sunday'] == null
        ? null
        : OpeningHoursDay.fromJson(json['sunday'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HoursOfOperationToJson(HoursOfOperation instance) =>
    <String, dynamic>{
      'monday': instance.monday?.toJson(),
      'tuesday': instance.tuesday?.toJson(),
      'wednesday': instance.wednesday?.toJson(),
      'thursday': instance.thursday?.toJson(),
      'friday': instance.friday?.toJson(),
      'saturday': instance.saturday?.toJson(),
      'sunday': instance.sunday?.toJson(),
    };

OpeningHoursDay _$OpeningHoursDayFromJson(Map<String, dynamic> json) {
  return OpeningHoursDay(
    open: json['open'] as String?,
    close: json['close'] as String?,
  );
}

Map<String, dynamic> _$OpeningHoursDayToJson(OpeningHoursDay instance) =>
    <String, dynamic>{
      'open': instance.open,
      'close': instance.close,
    };
