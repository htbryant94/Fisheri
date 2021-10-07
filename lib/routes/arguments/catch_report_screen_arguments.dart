// @dart=2.9

import 'package:fisheri/models/catch_report.dart';

class CatchReportScreenArguments {
  CatchReportScreenArguments({
    this.catchReport,
    this.catchReportID
  });

  final CatchReport catchReport;
  final String catchReportID;
}