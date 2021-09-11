// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catch_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatchReport _$CatchReportFromJson(Map<String, dynamic> json) {
  return CatchReport(
    id: json['id'] as String,
    endDate: json['end_date'] as String,
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    lakeID: json['lake_id'] as String?,
    lakeName: json['lake_name'] as String?,
    notes: json['notes'] as String?,
    startDate: json['start_date'] as String,
    userID: json['user_id'] as String,
  );
}

Map<String, dynamic> _$CatchReportToJson(CatchReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'end_date': instance.endDate,
      'images': instance.images,
      'lake_id': instance.lakeID,
      'lake_name': instance.lakeName,
      'notes': instance.notes,
      'user_id': instance.userID,
      'start_date': instance.startDate,
    };
