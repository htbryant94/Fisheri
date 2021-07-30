import 'package:fisheri/Screens/catch_report_form_screen.dart';
import 'package:fisheri/Screens/catch_report_screen.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../coordinator.dart';

class FisheriRoute {
  static CupertinoPageRoute catchReport(CatchReport catchReport, String catchReportID) {
    return CupertinoPageRoute(
        builder: (context) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Catch Report'),
              trailing: CupertinoButton(
                child: Icon(Icons.edit),
                padding: EdgeInsets.all(8),
                onPressed: () {
                  Coordinator.present(
                      context,
                      currentPageTitle: '',
                      screen: CatchReportFormScreen(
                        catchReport: catchReport,
                        catchReportID: catchReportID,
                      ),
                      screenTitle: 'Amend Catch Report'
                  );
                },
              ),
            ),
            child: CatchReportScreen(
              catchReport: catchReport,
              catchReportID: catchReportID,
            ),
          );
        }
    );
  }
}