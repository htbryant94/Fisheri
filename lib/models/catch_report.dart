import 'package:json_annotation/json_annotation.dart';
// part 'catch_report.g.dart';

@JsonSerializable()
class CatchReport {
  CatchReport({
    this.id,
    this.endDate,
    this.images,
    this.lakeID,
    this.lakeName,
    this.notes,
    this.startDate,
    this.userID,
  });

  String id;

  @JsonKey(name: 'end_date')
  String endDate;

  List<String> images;

  @JsonKey(name: 'lake_id')
  String lakeID;

  @JsonKey(name: 'lake_name')
  String lakeName;

  String notes;

  @JsonKey(name: 'user_id')
  String userID;

  @JsonKey(name: 'start_date')
  String startDate;

  // factory CatchReport.fromJson(Map<String, dynamic> json) => _$CatchReportFromJson(json);
  // Map<String, dynamic> toJson() => _$CatchReportToJson(this);
}
