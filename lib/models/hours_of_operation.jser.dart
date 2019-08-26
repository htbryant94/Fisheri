// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hours_of_operation.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$HoursOfOperationJSONSerializer
    implements Serializer<HoursOfOperation> {
  Serializer<OpeningHoursDay> __openingHoursDayJSONSerializer;
  Serializer<OpeningHoursDay> get _openingHoursDayJSONSerializer =>
      __openingHoursDayJSONSerializer ??= OpeningHoursDayJSONSerializer();
  @override
  Map<String, dynamic> toMap(HoursOfOperation model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'monday', _openingHoursDayJSONSerializer.toMap(model.monday));
    setMapValue(
        ret, 'tuesday', _openingHoursDayJSONSerializer.toMap(model.tuesday));
    setMapValue(ret, 'wednesday',
        _openingHoursDayJSONSerializer.toMap(model.wednesday));
    setMapValue(
        ret, 'thursday', _openingHoursDayJSONSerializer.toMap(model.thursday));
    setMapValue(
        ret, 'friday', _openingHoursDayJSONSerializer.toMap(model.friday));
    setMapValue(
        ret, 'saturday', _openingHoursDayJSONSerializer.toMap(model.saturday));
    setMapValue(
        ret, 'sunday', _openingHoursDayJSONSerializer.toMap(model.sunday));
    return ret;
  }

  @override
  HoursOfOperation fromMap(Map map) {
    if (map == null) return null;
    final obj = HoursOfOperation();
    obj.monday = _openingHoursDayJSONSerializer.fromMap(map['monday'] as Map);
    obj.tuesday = _openingHoursDayJSONSerializer.fromMap(map['tuesday'] as Map);
    obj.wednesday =
        _openingHoursDayJSONSerializer.fromMap(map['wednesday'] as Map);
    obj.thursday =
        _openingHoursDayJSONSerializer.fromMap(map['thursday'] as Map);
    obj.friday = _openingHoursDayJSONSerializer.fromMap(map['friday'] as Map);
    obj.saturday =
        _openingHoursDayJSONSerializer.fromMap(map['saturday'] as Map);
    obj.sunday = _openingHoursDayJSONSerializer.fromMap(map['sunday'] as Map);
    return obj;
  }
}

abstract class _$OpeningHoursDayJSONSerializer
    implements Serializer<OpeningHoursDay> {
  @override
  Map<String, dynamic> toMap(OpeningHoursDay model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'open', model.open);
    setMapValue(ret, 'close', model.close);
    return ret;
  }

  @override
  OpeningHoursDay fromMap(Map map) {
    if (map == null) return null;
    final obj = OpeningHoursDay();
    obj.open = map['open'] as String;
    obj.close = map['close'] as String;
    return obj;
  }
}
