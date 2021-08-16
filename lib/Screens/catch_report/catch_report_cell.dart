// @dart=2.9

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fisheri/Components/base_cell.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../coordinator.dart';

class CatchReportCell extends StatelessWidget {
  CatchReportCell({
    this.catchReport,
    this.catchReportID,
  });

  final CatchReport catchReport;
  final String catchReportID;

  String formatDatePresentable() {
    String _presentableDate;
    if (catchReport.startDate != null) {
      final _formattedDate = DateFormat('dd/MM/yy').format(DateTime.parse(catchReport.startDate));
      _presentableDate = _formattedDate;
    }
    if (catchReport.endDate != null && catchReport.endDate != catchReport.startDate) {
      final _formattedDate = DateFormat('dd/MM/yy').format(DateTime.parse(catchReport.endDate));
      _presentableDate += ' - $_formattedDate';
    }
    return _presentableDate;
  }

  String dateLabel() {
    final dateText = formatDatePresentable();
    if (dateText != null) {
      return dateText;
    } else {
      return 'No dates specified';
    }
  }

  Future<String> _fetchImages() async {
    if (catchReport.images != null && catchReport.images.isNotEmpty) {
      return await FirebaseStorage.instance.ref('catch_reports/$catchReportID/images/0').getDownloadURL();
    } else {
      return await FirebaseStorage.instance.ref('venues/${catchReport.lakeID}/images/0').getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Coordinator.pushCatchReportScreen(
          context,
          currentPageTitle: 'Catch Reports',
          catchReport: catchReport,
          catchReportID: catchReportID
        );
      },
      child: (catchReport.images != null && catchReport.images.isNotEmpty) ? FutureBuilder<String> (
        future: _fetchImages(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return RemoteImageBaseCell(
              title: catchReport.lakeName,
              subtitle: dateLabel(),
              imageURL: snapshot.data,
              height: 278,
              layout: BaseCellLayout.cover,
            );
          } else {
              return Container(
                height: 278,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
      },
      ) :
      RemoteImageBaseCell(
        showImage: false,
        title: catchReport.lakeName,
        subtitle: dateLabel(),
        height: 278,
        layout: BaseCellLayout.cover,
      ),
    );
  }
}