import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'catch_report.jser.dart';

@GenSerializer(
  serializers: [],
  fields: {
    'lakeID': EnDecode(alias: 'lake_id'),
    'lakeName': EnDecode(alias: 'lake_name'),
    'startDate': EnDecode(alias: 'start_date'),
    'endDate': EnDecode(alias: 'end_date'),
    'userID': EnDecode(alias: 'user_id'),
  },
)

class CatchReportJSONSerializer extends Serializer<CatchReport>
    with _$CatchReportJSONSerializer {}

class CatchReport {
  CatchReport({
    this.userID,
    this.lakeID,
    this.lakeName,
    this.startDate,
    this.endDate,
    this.images,
    this.notes,
  });

  String userID;
  String lakeID;
  String lakeName;
  String startDate;
  String endDate;
  String notes;
  List<String> images;
}
