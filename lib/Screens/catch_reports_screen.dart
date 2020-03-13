import 'dart:ui';

import 'package:fisheri/Screens/catch_report_form_screen.dart';
import 'package:fisheri/Screens/catch_report_screen.dart';
import 'package:fisheri/house_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CatchReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(child: CatchReportListBuilder()),
                CupertinoButton(
                  onPressed: () {
                    Firestore.instance
                    .collection('venues_locations')
                    .getDocuments()
                    .then((documents) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CatchReportFormScreen(
                              availableLakes: documents)));
                });
                  },
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.add, color: Colors.white),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                          'Add a new Catch Report',
                          style: GoogleFonts.raleway(
                            color: HouseColors.midnightBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                      ))
                    ],
                  ),
                )
            ],
            ),
        ),
      );
  }
}

class CatchReportListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('catch_reports').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return ListView.builder(
          padding: EdgeInsets.all(8),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final _catchReport = snapshot.data.documents[index];
              return CatchReportCell(
                name: _catchReport['lake_name'],
                startDate: DateTime.parse(_catchReport['start_date']),
                endDate: DateTime.parse(_catchReport['end_date']),
                id: _catchReport.documentID,
              );
            });
      },
    );
  }
}

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

  Text dateLabel() {
    String dateText = formatDatePresentable();
    if (dateText != null) {
      return Text(
        dateText,
        style: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: HouseColors.asbestos,
        ),
      );
    } else {
      return Text('No dates specified');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        print('name: $name');
//        print('start date: $startDate');
//        print('end date: $endDate');
//        print('id: $id');
//        print('------------------------');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CatchReportScreen(
              startDate: startDate,
              endDate: endDate,
              id: id,
            )));
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3,
//        margin: EdgeInsets.only(top: 4, bottom: 4),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 4,
                child: Image.asset(
                  'images/lake.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          color: HouseColors.wetAsphalt,
                        ),
                      ),
                      SizedBox(height: 8),
                      dateLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}