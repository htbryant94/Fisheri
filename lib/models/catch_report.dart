import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'catch_report.jser.dart';

@GenSerializer(
  serializers: [],
  fields: {
    'lakeID': EnDecode(alias: 'lake_id'),
    'lakeName': EnDecode(alias: 'lake_name'),
    'startDate': EnDecode(alias: 'start_date'),
    'endDate': EnDecode(alias: 'end_date'),
  },
)

class CatchReportJSONSerializer extends Serializer<CatchReport>
    with _$CatchReportJSONSerializer {}

class CatchReport {
  CatchReport({
    this.lakeID,
    this.lakeName,
    this.startDate,
    this.endDate,
  });

  String lakeID;
  String lakeName;
  String startDate;
  String endDate;
}
