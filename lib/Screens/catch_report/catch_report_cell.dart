import 'package:fisheri/Components/base_cell.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../coordinator.dart';

class CatchReportCell extends StatelessWidget {
  CatchReportCell({
    this.name,
    this.startDate,
    this.endDate,
    this.id,
  });

  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String id;

  String formatDatePresentable() {
    String _presentableDate;
    if (startDate != null) {
      String _formattedDate = DateFormat('dd/MM/yy').format(startDate);
      _presentableDate = _formattedDate;
    }
    if (endDate != null) {
      String _formattedDate = DateFormat('dd/MM/yy').format(endDate);
      _presentableDate += " - $_formattedDate";
    }
    return _presentableDate;
  }

  String dateLabel() {
    String dateText = formatDatePresentable();
    if (dateText != null) {
      return dateText;
    } else {
      return 'No dates specified';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Coordinator.pushCatchReportScreen(
          context,
          currentPageTitle: 'Catch Reports',
          id: id,
          startDate: startDate,
          endDate: endDate,
        );
      },
      child: RemoteImageBaseCell(
        title: name,
        subtitle: dateLabel(),
        imageURL: null,
        height: 278,
        layout: BaseCellLayout.cover,
      ),
    );
  }
}