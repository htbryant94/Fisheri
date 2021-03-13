// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catch_report.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$CatchReportJSONSerializer implements Serializer<CatchReport> {
  @override
  Map<String, dynamic> toMap(CatchReport model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'lake_id', model.lakeID);
    setMapValue(ret, 'lake_name', model.lakeName);
    setMapValue(ret, 'start_date', model.startDate);
    setMapValue(ret, 'end_date', model.endDate);
    setMapValue(
        ret, 'images', codeIterable(model.images, (val) => val as String));
    return ret;
  }

  @override
  CatchReport fromMap(Map map) {
    if (map == null) return null;
    final obj = CatchReport();
    obj.lakeID = map['lake_id'] as String;
    obj.lakeName = map['lake_name'] as String;
    obj.startDate = map['start_date'] as String;
    obj.endDate = map['end_date'] as String;
    obj.images =
        codeIterable<String>(map['images'] as Iterable, (val) => val as String);
    return obj;
  }
}
