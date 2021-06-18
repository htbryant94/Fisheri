import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisheri/alert_dialog_factory.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

// DateFormat
import 'package:intl/intl.dart';

class CatchReportFormScreen extends StatefulWidget {
  CatchReportFormScreen();

  @override
  _CatchReportFormScreenState createState() => _CatchReportFormScreenState();
}

class _CatchReportFormScreenState extends State<CatchReportFormScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  bool isDayOnly;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedReportType = 'lake';
  List<String> imageURLs = [];
  bool _isLoading = false;
  String _loadingText = 'Loading...';
  QuerySnapshot _availableLakes;

  @override
  void initState() {
    super.initState();
    isDayOnly = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                  },
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      Visibility(
                        visible: true,
                        child: Column(
                          children: [
                            HouseTexts.subheading('Your Title *'),
                            FormBuilderTextField(
                              name: 'custom_name',
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
                                  name: 'date_start',
                                  inputType: InputType.date,
                                  format: DateFormat('dd-MM-yyyy'),
                                  decoration: InputDecoration(labelText: 'Start date'),
                                  validator: FormBuilderValidators.compose(
                                      [
                                        FormBuilderValidators.required(context)
                                      ]
                                  ),
                                  onChanged: (date) {
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
                                name: 'date_one_day_only',
                                initialValue: false,
                                title: Text('Day only'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    setState(() {
                                      isDayOnly = value;
                                    });
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
                          ),
                        ),
                      ),
                      DSComponents.paragraphSpacer(),
                      FormBuilderTextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: null,
                        name: 'notes',
                        decoration: InputDecoration(
                            labelText: 'Notes', border: OutlineInputBorder()),
                      ),
                      DSComponents.paragraphSpacer(),
                      DSComponents.header(text: 'Photos'),
                      DSComponents.singleSpacer(),
                      DSComponents.subheaderSmall(text: 'The first photo will be the cover of your report'),
                      DSComponents.singleSpacer(),
                      FormBuilderImagePicker(
                        name: 'images',
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                DSComponents.primaryButton(
                  text: 'Create',
                  onPressed: () async {
                    if (_fbKey.currentState.validate()) {
                      _setLoadingState(true, message: 'Please wait...');

                      final uniqueID = Uuid().v1();

                      // 1. Upload images to storage
                      if (_valueFor(attribute: 'images') != null) {
                        _updateLoadingMessage('Saving your Photos...');
                        final _images = _valueFor(attribute: 'images');
                        var index = 0;

                        print('uploading images: $_images');

                        await Future.forEach(_images, (image) async {
                          final reference = FirebaseStorage.instance.ref().child('catch_reports/$uniqueID/images/$index');

                          await reference.putFile(image).whenComplete(() async {
                            print('putting file');
                            await reference.getDownloadURL().then((fileURL) {
                              print('getting download URL');
                              setState(() {
                                print('setting imageURLs');
                                imageURLs.add(fileURL);
                              });
                            });
                          }).catchError((error) {
                            print('error putting file: $error');
                          });
                          index += 1;
                        });

                        print('finished uploading images');
                      }

                      _updateLoadingMessage('Creating your Catch Report...');

                      // 2. Create CatchReport Model
                      print ('creating CatchReport model');
                      String _lakeID;
                      DocumentSnapshot _document;
                      DateTime _startDate;
                      DateTime _endDate;

                      if (selectedReportType == 'lake') {
                        _lakeID = _valueFor(attribute: 'lake_name');
                        // _document = widget.availableLakes.docs.firstWhere((lake) => lake.id == _lakeID);
                      }

                      if (_valueFor(attribute: 'date_start') != null) {
                        _startDate =  _valueFor(attribute: 'date_start');
                      }

                      if (!isDayOnly && _valueFor(attribute: 'date_end') != null) {
                        _endDate = _valueFor(attribute: 'date_end');
                      }  else {
                        _endDate = _startDate;
                      }

                      final _isCustomLake = selectedReportType == 'custom';

                      final _catchReport = CatchReport(
                        userID: FirebaseAuth.instance.currentUser.uid,
                        lakeID: _isCustomLake ? null : _document.id,
                        lakeName: _isCustomLake ? _valueFor(attribute: 'custom_name') : _document['name'],
                        startDate: _startDate.toIso8601String(),
                        endDate: _endDate.toIso8601String(),
                        images: imageURLs.isNotEmpty ? imageURLs : null,
                        notes: _valueFor(attribute: 'notes'),
                      );

                      print('created');
                      _updateLoadingMessage('Saving your Catch Report...');

                      // 3. Upload Model to DB
                      print('uploading catch report');
                      final _catchReportJSON = CatchReportJSONSerializer().toMap(_catchReport);

                      await _firestore
                          .collection('catch_reports')
                          .doc(uniqueID)
                          .set(_catchReportJSON)
                          .whenComplete(() {
                        print('catch report added successfully');

                        _setLoadingState(false);

                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Coordinator.pushCatchReportScreen(
                            context,
                            catchReportID: uniqueID,
                            catchReport: _catchReport
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
