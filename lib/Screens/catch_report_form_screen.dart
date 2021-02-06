import 'package:fisheri/house_texts.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedReportType = "lake";

  @override
  void initState() {
    super.initState();
    isDayOnly = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {
                'catch_type': "lake",
              },
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: <Widget>[
                  HouseTexts.heading('New Report'),
                  SizedBox(height: 16),
                  FormBuilderRadioGroup(
                    name: 'catch_type',
                    options: [
                      FormBuilderFieldOption(
                        value: 'lake',
                        child: Text('Specified Lake'),
                      ),
                      FormBuilderFieldOption(
                        value: 'custom',
                        child: Text('Custom'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedReportType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: selectedReportType == "lake",
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 300,
                        child: Column(
                          children: [
                            HouseTexts.subheading('Specified Lake *'),
                            _LakesDropDownMenu(
                              isEnabled: selectedReportType == "lake",
                              snapshotLakes: widget.availableLakes,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedReportType == "custom",
                    child: Column(
                      children: [
                        HouseTexts.subheading('Custom Name *'),
                        FormBuilderTextField(
                          name: "custom_name",
                          validator: selectedReportType == "custom" ?
                              FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(context),
                                    FormBuilderValidators.minLength(context, 3),
                                  ]
                              ) : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  FormBuilderDateTimePicker(
                    name: 'date_start',
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    decoration: InputDecoration(labelText: 'Start date'),
                    onChanged: (date) {
                      if (date != null) {
                        print('date set to: ${date.toIso8601String()}');
                      }
                    },
                  ),
                  FormBuilderCheckbox(
                    name: 'date_one_day_only',
                    title: Text('Day only?'),
                    onChanged: (value) {
                      setState(() {
                        setState(() {
                          isDayOnly = value;
                        });
                      });
                    },
                  ),
                  Visibility(
                    visible: !isDayOnly,
                    child: FormBuilderDateTimePicker(
                      name: 'date_end',
                      inputType: InputType.date,
                      format: DateFormat('dd-MM-yyyy'),
                      decoration: InputDecoration(labelText: 'End date'),
                      onChanged: (date) {
                        if (date != null) {
                          print('date set to: ${date.toIso8601String()}');
                        }
                      },
                    ),
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
                if (_fbKey.currentState.validate()) {

                  CatchReport _report;

                  DateTime _startDate =
                      _fbKey.currentState.fields['date_start'].value;
                  String _dateEnd = isDayOnly ? 'date_start' : 'date_end';
                  DateTime _endDate =
                      _fbKey.currentState.fields[_dateEnd].value;

                  if (selectedReportType == "lake") {
                    String _documentID = _fbKey.currentState.fields['lake_name'].value;
                    DocumentSnapshot _document = widget.availableLakes.docs
                        .firstWhere((lake) => lake.id == _documentID);
                    final _lakeID = _document.id;
                    String _lakeName = _document['name'];
                    _report = CatchReport(
                      lakeID: _lakeID,
                      lakeName: _lakeName,
                      startDate: _startDate.toIso8601String(),
                      endDate: _endDate.toIso8601String(),
                    );
                  } else if (selectedReportType == "custom") {
                    String _customName = _fbKey.currentState.fields['custom_name'].value;
                    _report = CatchReport(
                      lakeID: null,
                      lakeName: _customName,
                      startDate: _startDate.toIso8601String(),
                      endDate: _endDate.toIso8601String(),
                    );
                  }

                  final _reportJSON = CatchReportJSONSerializer().toMap(
                      _report);
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
                } else {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'There was an issue trying to submit your form'),
                          content: SingleChildScrollView(
                            child: Text(
                                'Please correct any incorrect entries and try again.'),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class _LakesDropDownMenu extends StatelessWidget {
  _LakesDropDownMenu({
    this.snapshotLakes,
    this.isEnabled,
  });

  final QuerySnapshot snapshotLakes;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: 'lake_name',
        items: snapshotLakes.docs.map((lake) {
          return DropdownMenuItem(
            child: (Text(lake['name'])),
            value: lake.id,
          );
        }).toList(),
      validator: isEnabled ?
          FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(context),
                FormBuilderValidators.minLength(context, 3),
              ]
          ) : null,
    );
  }
}
