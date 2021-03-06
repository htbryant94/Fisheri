// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catch.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$CatchJSONSerializer implements Serializer<Catch> {
  @override
  Map<String, dynamic> toMap(Catch model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'catch_type', model.catchType);
    setMapValue(ret, 'catch_report_id', model.catchReportID);
    setMapValue(ret, 'date', model.date);
    setMapValue(ret, 'notes', model.notes);
    setMapValue(ret, 'num_of_fish', model.numberOfFish);
    setMapValue(ret, 'position', model.position);
    setMapValue(ret, 'temperature', model.temperature);
    setMapValue(ret, 'time', model.time);
    setMapValue(ret, 'type_of_fish', model.typeOfFish);
    setMapValue(ret, 'weather_condition', model.weatherCondition);
    setMapValue(ret, 'weight', model.weight);
    setMapValue(ret, 'wind_direction', model.windDirection);
    setMapValue(
        ret, 'images', codeIterable(model.images, (val) => val as String));
    return ret;
  }

  @override
  Catch fromMap(Map map) {
    if (map == null) return null;
    final obj = Catch();
    obj.catchType = map['catch_type'] as String;
    obj.catchReportID = map['catch_report_id'] as String;
    obj.date = map['date'] as String;
    obj.notes = map['notes'] as String;
    obj.numberOfFish = map['num_of_fish'] as int;
    obj.position = map['position'] as int;
    obj.temperature = map['temperature'] as double;
    obj.time = map['time'] as String;
    obj.typeOfFish = map['type_of_fish'] as String;
    obj.weatherCondition = map['weather_condition'] as String;
    obj.weight = map['weight'] as double;
    obj.windDirection = map['wind_direction'] as String;
    obj.images =
        codeIterable<String>(map['images'] as Iterable, (val) => val as String);
    return obj;
  }
}
