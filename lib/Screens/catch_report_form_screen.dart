// @dart=2.9

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisheri/FirestoreCollections.dart';
import 'package:fisheri/Screens/catch_report_screen.dart';
import 'package:fisheri/Factories/alert_dialog_factory.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:fisheri/routes/arguments/catch_report_screen_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

// DateFormat
import 'package:intl/intl.dart';

import '../coordinator.dart';
import 'ImageUploadScreen.dart';

class CatchReportFormConstants {
  static const String customName = 'custom_name';
  static const String lakeName = 'lake_name';
  static const String dateStart = 'date_start';
  static const String dateEnd = 'date_end';
  static const String dateDayOnly = 'date_day_only';
  static const String notes = 'notes';
  static const String images = 'images';
}

class CatchReportFormScreen extends StatefulWidget {
  CatchReportFormScreen({
    this.catchReport,
    this.catchReportID,
    this.onFormSubmitted
});

  final CatchReport catchReport;
  final String catchReportID;
  final ValueChanged<CatchReport> onFormSubmitted;

  @override
  _CatchReportFormScreenState createState() => _CatchReportFormScreenState();
}

class _CatchReportFormScreenState extends State<CatchReportFormScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  bool isDayOnly;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedReportType = 'custom';
  List<String> imageURLs = [];
  bool _isLoading = false;
  String _loadingText = 'Loading...';
  QuerySnapshot _availableLakes;
  bool _isEditMode;
  final _imagesEnabled = false;

  @override
  void initState() {
    _isEditMode = widget.catchReport != null;
    if (widget.catchReport != null) {
      final startDate = DateTime.parse(widget.catchReport.startDate);
      final endDate = DateTime.parse(widget.catchReport.endDate);
      isDayOnly = startDate == endDate;
      if (widget.catchReport.images != null && widget.catchReport.images.isNotEmpty) {
        imageURLs = widget.catchReport.images.map((e) => e.url).toList();
      }
    } else {
      isDayOnly = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Listener(
          onPointerDown: (_) {
            var currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
            }
          },
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  FormBuilder(
                    key: _fbKey,
                    initialValue: widget.catchReport != null ? {
                      CatchReportFormConstants.customName: widget.catchReport.lakeName,
                      CatchReportFormConstants.dateStart: DateTime.parse(widget.catchReport.startDate),
                      CatchReportFormConstants.dateEnd: DateTime.parse(widget.catchReport.endDate),
                      CatchReportFormConstants.notes: widget.catchReport.notes,
                      CatchReportFormConstants.images: widget.catchReport.images,
                    } : null,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        Visibility(
                          visible: true,
                          child: Column(
                            children: [
                              HouseTexts.subheading('Your Title *'),
                              FormBuilderTextField(
                                name: CatchReportFormConstants.customName,
                                validator: selectedReportType == 'custom' ?
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
                        if(_availableLakes != null)
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      HouseTexts.subheading('Specified Lake *'),
                                      _LakesDropDownMenu(
                                        isEnabled: selectedReportType == 'lake',
                                        snapshotLakes: _availableLakes,
                                      ),
                                      DSComponents.doubleSpacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                                child: Container(
                                  width: 150,
                                  child: FormBuilderDateTimePicker(
                                    name: CatchReportFormConstants.dateStart,
                                    inputType: InputType.date,
                                    format: DateFormat('dd-MM-yyyy'),
                                    decoration: InputDecoration(labelText: 'Start date'),
                                    validator: FormBuilderValidators.compose(
                                        [
                                          FormBuilderValidators.required(context)
                                        ]
                                    ),
                                    onChanged: (date) {
                                      print('changed: $date');
                                      if (date != null) {
                                        print('date set to: ${date.toIso8601String()}');
                                      }
                                    },
                                  ),
                                ),
                            ),
                            Flexible(
                              flex: 1,
                                child: FormBuilderCheckbox(
                                  name: CatchReportFormConstants.dateDayOnly,
                                  initialValue: isDayOnly,
                                  title: Text('Day only'),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  valueTransformer: (value) {
                                    print(value);
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      isDayOnly = value;
                                    });
                                  },
                                ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: !isDayOnly,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 150,
                              child: FormBuilderDateTimePicker(
                                name: CatchReportFormConstants.dateEnd,
                                inputType: InputType.date,
                                format: DateFormat('dd-MM-yyyy'),
                                decoration: InputDecoration(labelText: 'End date'),
                                valueTransformer: (value) {
                                  print(value);
                                },

                                onChanged: (date) {
                                  print('changed: $date');
                                  if (date != null) {
                                    print('date set to: ${date.toIso8601String()}');
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        DSComponents.paragraphSpacer(),
                        FormBuilderTextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: 100,
                          name: CatchReportFormConstants.notes,
                          decoration: InputDecoration(
                              labelText: 'Notes', border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  DSComponents.primaryButton(
                    text: 'Continue to Photos',
                    onPressed: () async {
                      if (_fbKey.currentState.validate()) {
                        _setLoadingState(true, message: 'Please wait...');

                        final _catchReportID = _isEditMode ? widget.catchReportID : Uuid().v1();

                        _updateLoadingMessage('Creating your Catch Report...');

                        // 2. Create CatchReport Model
                        print ('creating CatchReport model');
                        String _lakeID;
                        DocumentSnapshot _document;
                        DateTime _startDate;
                        DateTime _endDate;

                        if (selectedReportType == 'lake') {
                          _lakeID = _valueFor(attribute: CatchReportFormConstants.lakeName);
                          // _document = widget.availableLakes.docs.firstWhere((lake) => lake.id == _lakeID);
                        }

                        if (_valueFor(attribute: CatchReportFormConstants.dateStart) != null) {
                          _startDate =  _valueFor(attribute: CatchReportFormConstants.dateStart);
                        }

                        if (!isDayOnly && _valueFor(attribute: CatchReportFormConstants.dateEnd) != null) {
                          _endDate = _valueFor(attribute: CatchReportFormConstants.dateEnd);
                        }  else {
                          _endDate = _startDate;
                        }

                        final _isCustomLake = selectedReportType == 'custom';

                        final _catchReport = CatchReport(
                          id: _catchReportID,
                          userID: FirebaseAuth.instance.currentUser.uid,
                          lakeID: _isCustomLake ? null : _document.id,
                          lakeName: _isCustomLake ? _valueFor(attribute: CatchReportFormConstants.customName) : _document['name'],
                          startDate: _startDate.toIso8601String(),
                          endDate: _endDate.toIso8601String(),
                          images: widget.catchReport != null ? widget.catchReport.images : null,
                          notes: _valueFor(attribute: CatchReportFormConstants.notes),
                        );

                        print('created');
                        _updateLoadingMessage('Saving your Catch Report...');

                        // 3. Upload Model to DB
                        print('uploading catch report');
                        final _catchReportJSON = _catchReport.toJson();

                        await _firestore
                            .collection(FirestoreCollections.catchReports)
                            .doc(_catchReportID)
                            .set(_catchReportJSON, SetOptions(merge: false))
                            .catchError((onError) {
                              print('error uploading catch report: $onError');
                            })
                            .whenComplete(() {
                          print('catch report added successfully');

                          _setLoadingState(false);

                          Navigator.of(context).pop();
                          Coordinator.push(
                            context,
                            screenTitle: 'Your Photos',
                            screen: ImageUploadScreen(
                              documentReference: FirebaseFirestore.instance.collection(FirestoreCollections.catchReports).doc(_catchReportID),
                              storageReference: FirebaseStorage.instance.ref().child(FirestoreCollections.catchReports).child(_catchReportID).child('images'),
                              initialImages: widget.catchReport != null ? widget.catchReport.images : null,
                              onDonePressed: (cxt) {
                                if (!_isEditMode) {
                                  Navigator.popAndPushNamed(
                                    cxt,
                                    CatchReportScreen.routeName,
                                    arguments: CatchReportScreenArguments(
                                      catchReportID: _catchReportID,
                                      catchReport: _catchReport,
                                    ),
                                  );
                                } else {
                                  Navigator.pop(cxt);
                                }
                              },
                              onUpload: (images) {
                                final updatedCatchReport = _catchReport;
                                updatedCatchReport.images = images;
                                if (widget.onFormSubmitted != null) {
                                  widget.onFormSubmitted(_catchReport);
                                }
                              },
                            )
                          );
                        });
                      } else {
                        await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialogFactory.invalidFormSubmission(context);
                            });
                      }
                    },
                  )
                ],
              ),
              Visibility(
                visible: _isLoading,
                child: Positioned.fill(
                  child: AbsorbPointer(
                    child: Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 24),
                            HouseTexts.heading(_loadingText, alignment: Alignment.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _valueFor({String attribute}) {
    return _fbKey.currentState.fields[attribute].value;
  }

  void _setLoadingState(bool isLoading, {String message}) {
    setState(() {
      _isLoading = isLoading;
      _loadingText = message ?? 'Please wait...';
    });
  }

  void _updateLoadingMessage(String message) {
    setState(() {
      _loadingText = message;
    });
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
      name: CatchReportFormConstants.lakeName,
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
