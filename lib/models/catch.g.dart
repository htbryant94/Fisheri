// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catch _$CatchFromJson(Map<String, dynamic> json) {
  return Catch(
    id: json['id'] as String,
    catchReportID: json['catch_report_id'] as String,
    catchType: json['catch_type'] as String,
    date: json['date'] as String?,
    images: (json['images'] as List<dynamic>?)
        ?.map((e) => FisheriImage.fromJson(e as Map<String, dynamic>))
        .toList(),
    notes: json['notes'] as String?,
    numberOfFish: json['num_of_fish'] as int?,
    position: json['position'] as int?,
    temperature: (json['temperature'] as num?)?.toDouble(),
    time: json['time'] as String?,
    typeOfFish: json['type_of_fish'] as String?,
    userID: json['user_id'] as String,
    weatherCondition: json['weather_condition'] as String?,
    weight: (json['weight'] as num?)?.toDouble(),
    windDirection: json['wind_direction'] as String?,
  );
}

Map<String, dynamic> _$CatchToJson(Catch instance) => <String, dynamic>{
      'id': instance.id,
      'catch_report_id': instance.catchReportID,
      'catch_type': instance.catchType,
      'date': instance.date,
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
      'num_of_fish': instance.numberOfFish,
      'position': instance.position,
      'temperature': instance.temperature,
      'time': instance.time,
      'type_of_fish': instance.typeOfFish,
      'user_id': instance.userID,
      'weather_condition': instance.weatherCondition,
      'wind_direction': instance.windDirection,
      'weight': instance.weight,
    };
