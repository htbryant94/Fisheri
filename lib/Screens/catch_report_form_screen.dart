import 'package:fisheri/Screens/detail_screen/header.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fisheri/house_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// DateFormat
import 'package:intl/intl.dart';

class CatchReportFormScreen extends StatefulWidget {
  CatchReportFormScreen({this.availableLakes});

  final QuerySnapshot availableLakes;

  @override
  _CatchReportFormScreenState createState() => _CatchReportFormScreenState();
}

class _CatchReportFormScreenState extends State<CatchReportFormScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  bool isDayOnly;
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
    isDayOnly = false;
  }

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
                Header('New Report'),
                SizedBox(height: 16),
                __LakesDropDownMenu(snapshotLakes: widget.availableLakes),
                FormBuilderDateTimePicker(
                  attribute: 'date_start',
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  decoration: InputDecoration(labelText: 'Start date'),
                  onChanged: (date) {
                    print('date set to: ${date.toIso8601String()}');
                  },
                ),
                FormBuilderCheckbox(
                  attribute: 'date_one_day_only',
                  label: Text('Day only?'),
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        isDayOnly = value;
                      });
                    });
                  },
                ),
                FormBuilderDateTimePicker(
                  enabled: !isDayOnly,
                  attribute: 'date_end',
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  decoration: InputDecoration(labelText: 'End date'),
                  onChanged: (date) {
                    print('date set to: ${date.toIso8601String()}');
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 16),
          MaterialButton(
            child: Text(
              'Create',
              style: TextStyle(
                color: HouseColors.primaryGreen,
              ),
            ),
            color: HouseColors.accentGreen,
            onPressed: () {
              DocumentSnapshot _document =
                  _fbKey.currentState.fields['lake_name'].currentState.value;
              String _lakeID = _document.documentID;
              String _lakeName = _document['name'];
              DateTime _startDate =
                  _fbKey.currentState.fields['date_start'].currentState.value;
              String _dateEnd = isDayOnly ? 'date_start' : 'date_end';
              DateTime _endDate =
                  _fbKey.currentState.fields[_dateEnd].currentState.value;

              CatchReport _report = CatchReport(
                lakeID: _lakeID,
                lakeName: _lakeName,
                startDate: _startDate.toIso8601String(),
                endDate: _endDate.toIso8601String(),
              );

              final _reportJSON = CatchReportJSONSerializer().toMap(_report);
              _firestore
                  .collection('catch_reports')
                  .add(_reportJSON)
                  .whenComplete(() {
                print('catch report added successfully');
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Form successfully submitted'),
                        content: SingleChildScrollView(
                          child: Text(
                              'Tap Return to dismiss this page.'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Return'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _fbKey.currentState.reset();
                            },
                          )
                        ],
                      );
                    });
              });
            },
          )
        ],
      ),
    );
  }
}

class __LakesDropDownMenu extends StatelessWidget {
  __LakesDropDownMenu({this.snapshotLakes});

  final QuerySnapshot snapshotLakes;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      hint: Text('Search for a lake...'),
      attribute: 'lake_name',
      items: snapshotLakes.documents
          .map((lake) => DropdownMenuItem(
                child: (Text(lake["name"])),
                value: lake,
              ))
          .toList(),
    );
  }
}
