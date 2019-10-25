import 'package:fisheri/Screens/detail_screen/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fisheri/house_colors.dart';
import 'catch_form_screen_full.dart';

class CatchFormScreen extends StatefulWidget {
  CatchFormScreen({
    @required this.dateRange,
    @required this.catchReportID,
  });

  final List<DateTime> dateRange;
  final String catchReportID;

  @override
  _CatchFormScreenState createState() => _CatchFormScreenState();
}

class _CatchFormScreenState extends State<CatchFormScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final List<CatchType> catchTypes = [
    CatchType(
        name: "Single",
        icon: Icon(Icons.filter_1),
        detail: "Info text for Single"),
    CatchType(
        name: "Multi",
        icon: Icon(Icons.filter_3),
        detail: "Info text for Multi"),
    CatchType(
        name: "Match",
        icon: Icon(Icons.filter_5),
        detail: "Info text for Match"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fisheri'),
        backgroundColor: HouseColors.primaryGreen,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
        children: <Widget>[
          FormBuilder(
            key: _fbKey,
            initialValue: {},
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Header('Select the type of Catch'),
                SizedBox(height: 16),
                _CatchTypesListBuilder(
                  catchTypes: catchTypes,
                  dateRange: widget.dateRange,
                  catchReportID: widget.catchReportID,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CatchTypesListBuilder extends StatelessWidget {
  _CatchTypesListBuilder({
    @required this.catchTypes,
    @required this.dateRange,
    @required this.catchReportID,
  });

  final List<CatchType> catchTypes;
  final List<DateTime> dateRange;
  final String catchReportID;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: catchTypes
            .map((type) => _CatchTypeCell(
          type: type,
          dateRange: dateRange,
          catchReportID: catchReportID,
                ))
            .toList());
  }
}

class CatchType {
  CatchType({
    this.name,
    this.icon,
    this.detail,
  });

  final String name;
  final Icon icon;
  final String detail;
}

class _CatchTypeCell extends StatelessWidget {
  _CatchTypeCell({
    this.type,
    this.dateRange,
    @required this.catchReportID,
  });

  final CatchType type;
  final List<DateTime> dateRange;
  final String catchReportID;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CatchFormScreenFull(
                  dateRange: dateRange,
                  catchType: type,
                  catchReportID: catchReportID,
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24),
        height: 100,
        width: 240,
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: HouseColors.accentGreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.info_outline),
                  Text(
                    type.name,
                    style: TextStyle(
                      color: HouseColors.primaryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("PWA");
                    },
                    child: type.icon,
                    behavior: HitTestBehavior.translucent,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
