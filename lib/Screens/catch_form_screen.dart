import 'dart:ffi';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/alert_dialog_factory.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:fisheri/types/fish_stock_list.dart';
import 'package:fisheri/types/weather_condition.dart';
import 'package:fisheri/types/wind_direction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fisheri/models/catch.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';
import '../design_system.dart';

class CatchFormConstants {
  static const String catchType = 'catch_type';
  static const String date = 'date';
  static const String notes = 'notes';
  static const String numberOfFish = 'number_of_fish';
  static const String position = 'position';
  static const String temperature = 'temperature';
  static const String time = 'time';
  static const String typeOfFish = 'type_of_fish';
  static const String weatherCondition = 'weather_condition';
  static const String weightWhole = 'fish_weight_whole';
  static const String weightFraction = 'fish_weight_fraction';
  static const String windDirection = 'wind_direction';
  static const String images = 'images';
}

class CatchFormScreen extends StatefulWidget {
  CatchFormScreen({
    @required this.catchReportID,
    this.catchReport,
    this.catchID,
    this.catchData,
  });

  final String catchReportID;
  final String catchID;
  final Catch catchData;
  final CatchReport catchReport;

  @override
  _CatchFormScreenState createState() => _CatchFormScreenState();
}

class _CatchFormScreenState extends State<CatchFormScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final List<CatchType> catchTypes = CatchType.values;
  CatchType selectedCatchType;
  List<DateTime> dateRange;
  List<String> imageURLs = [];
  bool _isLoading = false;
  String _loadingText = 'Loading...';
  bool _didSetTemperature = false;
  bool _isEditMode;

  CatchType parseStringToCatchType(String catchType) {
    switch (catchType) {
    case 'single': return CatchType.single;
    case 'multi': return CatchType.multi;
    case 'match': return CatchType.match;
    case 'missed': return CatchType.missed;
    }
    return null;
  }

  @override
  void initState() {
    _isEditMode = widget.catchData != null;

    dateRange = makeDateRange(
      startDate: DateTime.parse(widget.catchReport.startDate),
      endDate: DateTime.parse(widget.catchReport.endDate),
    );

    if (_isEditMode) {
      selectedCatchType = parseStringToCatchType(widget.catchData.catchType);
    }

    super.initState();
  }

  double _convertFishWeight({int whole, int fraction}) {
    return WeightConverter.poundsAndOuncesToGrams(pounds: whole, ounces: fraction);
  }

  List<DateTime> makeDateRange({DateTime startDate, DateTime endDate}) {
    return List.generate(
        endDate.difference(startDate).inDays + 1,
            (day) => DateTime(startDate.year, startDate.month, startDate.day + day)
    );
  }

  Map<String, dynamic> populateSingleCatchValues(Catch catchData) {
    Weight _weight;
    DateTime _time;
    DateTime _date;

    if (catchData.weight != null) {
      _weight = WeightConverter.gramsToWeight(catchData.weight);
    }

    if (catchData.time != null) {
      _time = DateFormat('hh:mm').parse(catchData.time);
    }

    if (catchData.date != null) {
      _date = DateTime.parse(catchData.date);
    }

    return {
      CatchFormConstants.catchType: CatchType.single,
      CatchFormConstants.typeOfFish: catchData.typeOfFish,
      CatchFormConstants.weightWhole: _weight.pounds.toString(),
      CatchFormConstants.weightFraction: _weight.ounces.toString(),
      CatchFormConstants.time: _time,
      CatchFormConstants.date: _date,
      CatchFormConstants.weatherCondition: catchData.weatherCondition,
      CatchFormConstants.windDirection: catchData.windDirection,
      CatchFormConstants.notes: catchData.notes,
      CatchFormConstants.images: catchData.images,
    };
  }

  Map<String, dynamic> populateMultiCatchValues(Catch catchData) {
    Weight _weight;

    if (catchData.weight != null) {
      _weight = WeightConverter.gramsToWeight(catchData.weight);
    }

    return {
      CatchFormConstants.catchType: CatchType.multi,
      CatchFormConstants.typeOfFish: catchData.typeOfFish,
      CatchFormConstants.numberOfFish: catchData.numberOfFish,
      if (_weight != null)
      CatchFormConstants.weightWhole: _weight.pounds.toString(),
      if (_weight != null)
      CatchFormConstants.weightFraction: _weight.ounces.toString(),
      CatchFormConstants.weatherCondition: catchData.weatherCondition,
      CatchFormConstants.windDirection: catchData.windDirection,
      CatchFormConstants.notes: catchData.notes,
      CatchFormConstants.images: catchData.images,
    };
  }

  Map<String, dynamic> populateMatchCatchValues(Catch catchData) {
    Weight _weight;

    if (catchData.weight != null) {
      _weight = WeightConverter.gramsToWeight(catchData.weight);
    }

    return {
      CatchFormConstants.catchType: CatchType.match,
      CatchFormConstants.weightWhole: _weight.pounds.toString(),
      CatchFormConstants.weightFraction: _weight.ounces.toString(),
      CatchFormConstants.position: catchData.position,
      CatchFormConstants.weatherCondition: catchData.weatherCondition,
      CatchFormConstants.windDirection: catchData.windDirection,
      CatchFormConstants.notes: catchData.notes,
      CatchFormConstants.images: catchData.images,
    };
  }

  Map<String, dynamic> populateMissedCatchValues(Catch catchData) {
    DateTime _time;
    DateTime _date;

    if (catchData.time != null) {
      _time = DateFormat('hh:mm').parse(catchData.time);
    }

    if (catchData.date != null) {
      _date = DateTime.parse(catchData.date);
    }

    return {
      CatchFormConstants.catchType: CatchType.missed,
      CatchFormConstants.time: _time,
      CatchFormConstants.date: _date,
      CatchFormConstants.weatherCondition: catchData.weatherCondition,
      CatchFormConstants.windDirection: catchData.windDirection,
      CatchFormConstants.notes: catchData.notes,
      CatchFormConstants.images: catchData.images,
    };
  }

  Map<String, dynamic> populateRelevantValues({CatchType catchType, Catch catchData}) {
    switch (catchType) {
      case CatchType.single:
        return populateSingleCatchValues(catchData);
      case CatchType.multi:
        return populateMultiCatchValues(catchData);
      case CatchType.match:
        return populateMatchCatchValues(catchData);
      case CatchType.missed:
        return populateMissedCatchValues(catchData);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Listener(
          onPointerDown: (_) {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
            }
          },
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
                children: [
                  Column(
                    children: [
                      FormBuilder(
                        key: _fbKey,
                        initialValue: widget.catchData != null ?
                        populateRelevantValues(
                          catchData: widget.catchData,
                          catchType: parseStringToCatchType(widget.catchData.catchType),
                        ) : null,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          children: [
                            DSComponents.header(text: 'Catch Type'),
                            FormBuilderRadioGroup(
                              name: 'catch_type',
                              orientation: OptionsOrientation.horizontal,
                              options: catchTypes.map((type) =>
                                  FormBuilderFieldOption(
                                      value: type,
                                      child: Text(StringUtils.capitalize(describeEnum(type))))
                              ).toList(),
                              onChanged: (value) {
                                print('$value');
                                setState(() {
                                  selectedCatchType = value;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.single, CatchType.multi],
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 200,
                                  child: _TypeOfFishSection(
                                    title: 'Type of Fish *',
                                    attribute: CatchFormConstants.typeOfFish,
                                  ),
                                ),
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.multi],
                              child: _NumberOfFishSection(
                                initialValue: _isEditMode ? widget.catchData.numberOfFish : 0,
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.single, CatchType.multi, CatchType.match],
                              child: _FishWeight(
                                isRequired: (selectedCatchType != CatchType.multi),
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.match],
                              child: _PositionSection(
                                title: 'Position',
                                attribute: CatchFormConstants.position,
                                initialValue: _isEditMode ? widget.catchData.position : 0,
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.single, CatchType.missed],
                              child: _TimePickerBuilder(
                                title: 'Time',
                                attribute: CatchFormConstants.time,
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.single, CatchType.missed],
                              child: _DropDownMenuDatesBuilder(
                                title: 'Date',
                                attribute: CatchFormConstants.date,
                                items: dateRange,
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: CatchType.values,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 200,
                                  child: _DropDownMenuBuilder(
                                    title: 'Weather Conditions',
                                    attribute: CatchFormConstants.weatherCondition,
                                      items: WeatherCondition.values.map((condition) => describeEnum(condition)).toList()
                                  ),
                                ),
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: CatchType.values,
                              child: _DropDownMenuBuilder(
                                title: 'Wind Direction',
                                attribute: CatchFormConstants.windDirection,
                                items: WindDirection.values.map((windDirection) => describeEnum(windDirection)).toList(),
                              ),
                            ),
                            CatchReportVisibility(
                                catchType: selectedCatchType,
                                supportedCatchTypes: CatchType.values,
                                child: _TemperatureSlider(
                                  initialValue: widget.catchData != null ? widget.catchData.temperature : 0,
                                  valueChanged: (value) {
                                    setState(() {
                                      _didSetTemperature = true;
                                    });
                                  },
                                )
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: CatchType.values,
                              child: FormBuilderTextField(
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: null,
                                name: CatchFormConstants.notes,
                                decoration: InputDecoration(
                                    labelText: 'Notes', border: OutlineInputBorder()),
                              ),
                            ),
                            Visibility(
                              visible: _isEditMode ? widget.catchData.images != null : true,
                              child: FormBuilderImagePicker(
                                name: CatchFormConstants.images,
                                enabled: !_isEditMode,
                                decoration: InputDecoration(
                                  border: InputBorder.none
                                ),
                                onChanged: (value) {
                                  print('image value changes: $value');
                                },
                              ),
                            ),
                            DSComponents.doubleSpacer(),
                            DSComponents.primaryButton(
                              text: 'Log your Catch',
                              onPressed: () async {
                                if(_fbKey.currentState.validate()) {
                                  _setLoadingState(true, message: 'Creating your Catch...');

                                  // 1. Create CatchModel
                                  Catch catchModel;
                                  // COMMON

                                  String typeOfFish;

                                  DateTime time;
                                  var _weight;
                                  var _weatherCondition;
                                  var _windDirection;
                                  double _temperature;
                                  var _notes;

                                  if (selectedCatchType != CatchType.missed) {
                                    if (_valueFor(attribute: CatchFormConstants.weightWhole) != null) {
                                      var _weightFraction = 0;

                                      if (_valueFor(attribute: CatchFormConstants.weightFraction) != null) {
                                        _weightFraction = int.parse(
                                            _valueFor(attribute: CatchFormConstants.weightFraction),
                                            onError: (_) { return 0; });
                                      }

                                      _weight = _convertFishWeight(
                                          whole: int.parse(_valueFor(attribute: CatchFormConstants.weightWhole)),
                                          fraction: _weightFraction
                                      );
                                    }
                                  }

                                  if (_valueFor(attribute: CatchFormConstants.weatherCondition) != null) {
                                    _weatherCondition = _valueFor(attribute: CatchFormConstants.weatherCondition);
                                  }

                                  if (_valueFor(attribute: CatchFormConstants.windDirection) != null) {
                                    _windDirection = _valueFor(attribute: CatchFormConstants.windDirection);
                                  }

                                  if (_valueFor(attribute: CatchFormConstants.temperature) != null && _didSetTemperature) {
                                    _temperature = _valueFor(attribute: CatchFormConstants.temperature);
                                  }

                                  if (_valueFor(attribute: CatchFormConstants.notes) != null) {
                                    _notes = _valueFor(attribute: CatchFormConstants.notes);
                                  }

                                  DateTime date;
                                  int numberOfFish;
                                  int position;

                                  if (selectedCatchType == CatchType.single) {
                                    typeOfFish = _valueFor(attribute: CatchFormConstants.typeOfFish);
                                    time = _valueFor(attribute: CatchFormConstants.time);
                                    date = _valueFor(attribute: CatchFormConstants.date);
                                  }
                                  else if (selectedCatchType == CatchType.multi) {
                                    typeOfFish = _valueFor(attribute: CatchFormConstants.typeOfFish);
                                    numberOfFish = _valueFor(attribute: CatchFormConstants.numberOfFish);
                                  }
                                  else if (selectedCatchType == CatchType.match) {
                                    position = _valueFor(attribute: CatchFormConstants.position);
                                  }
                                  else if (selectedCatchType == CatchType.missed) {
                                    time = _valueFor(attribute: CatchFormConstants.time);
                                    date = _valueFor(attribute: CatchFormConstants.date);
                                  }

                                  print('creating catch');

                                  catchModel = Catch(
                                    userID: FirebaseAuth.instance.currentUser.uid,
                                    catchType: describeEnum(selectedCatchType),
                                    catchReportID: widget.catchReportID,
                                    date: date != null ? date.toIso8601String() : null,
                                    notes: _notes,
                                    numberOfFish: numberOfFish,
                                    position: position != null ? position : null,
                                    temperature: _temperature,
                                    time: time != null ? DateFormat('HH:mm').format(time) : null,
                                    typeOfFish: typeOfFish,
                                    weatherCondition: _weatherCondition,
                                    weight: _weight,
                                    windDirection: _windDirection,
                                    images: null
                                  );

                                  print('catch report successfully created:');
                                  print('catchType: ${catchModel.catchType}');

                                  _updateLoadingMessage('Saving your Catch...');

                                  final _catchID = _isEditMode ? widget.catchID : Uuid().v1();

                                  // 2. Upload catch to database
                                  final catchJSON = CatchJSONSerializer().toMap(catchModel);
                                  await FirebaseFirestore.instance
                                      .collection('catches')
                                      .doc(_catchID)
                                      .set(catchJSON, SetOptions(merge: false))
                                      .whenComplete(() async {

                                    print('catch added successfully: $_catchID');

                                    // 3. Upload images to storage
                                    if (!_isEditMode) {
                                      if (_valueFor(attribute: 'images') != null) {
                                        print('uploading images');
                                        _updateLoadingMessage(
                                            'Saving your Photos...');

                                        final _images = _valueFor(
                                            attribute: 'images');
                                        var index = 0;

                                        await Future.forEach(
                                            _images, (image) async {
                                          final storageReference = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child('catch_reports/${widget
                                              .catchReportID}/$_catchID/$index');

                                          await storageReference
                                              .putFile(image)
                                              .whenComplete(() async {
                                            await storageReference
                                                .getDownloadURL()
                                                .then((fileURL) {
                                              // 4. Fetch downloadURLs and populate imageURLs
                                              setState(() {
                                                imageURLs.add(fileURL);
                                              });
                                            });
                                          });
                                          index += 1;
                                        });

                                        _updateLoadingMessage('Finalising...');
                                        print('finished uploading images');
                                      }
                                    }

                                    // 5. Amend database entry with imageURLs
                                    if (imageURLs.isNotEmpty) {
                                      print('amending Catch');

                                      catchModel.images = imageURLs;
                                      final amendedCatchJSON = CatchJSONSerializer().toMap(catchModel);

                                      await FirebaseFirestore.instance
                                          .collection('catches')
                                          .doc(_catchID)
                                          .set(amendedCatchJSON)
                                          .whenComplete(() {
                                          });
                                    }
                                    _setLoadingState(false);
                                    Navigator.of(context).pop();

                                    // Dismisses the Detail Screen after edit is complete
                                    if (_isEditMode) {
                                      Navigator.of(context).pop();
                                    }
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
                      )
                    ],
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
                            DSComponents.header(text: _loadingText, alignment: Alignment.center),
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
    return _fbKey
        .currentState.fields[attribute].value;
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

class _NumberOfFishSection extends StatelessWidget {
  _NumberOfFishSection({
    this.initialValue,
});

  final int initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: 'Number of Fish'),
        FormBuilderTouchSpin(
          name: CatchFormConstants.numberOfFish,
          initialValue: initialValue ?? 0,
          min: 0,
          max: 100,
          step: 1,
          validator: FormBuilderValidators.min(context, 1, errorText: 'Please specify the number of fish caught.'),
        ),
      ],
    );
  }
}


class _PositionSection extends StatelessWidget {
  _PositionSection({
    @required this.title,
    @required this.attribute,
    this.initialValue,
  });
  final String title;
  final String attribute;
  final int initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: title),
        FormBuilderTouchSpin(
          name: attribute,
          initialValue: initialValue ?? 0,
          min: 1,
          max: 10,
          step: 1,
          validator: FormBuilderValidators.min(context, 1, errorText: 'Please specify the position.'),
        )
      ],
    );
  }
}

class _TimePickerBuilder extends StatelessWidget {
  _TimePickerBuilder({
    @required this.title,
    @required this.attribute,
  });

  final String title;
  final String attribute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: title),
        FormBuilderDateTimePicker(
          name: attribute,
          inputType: InputType.time,
        )
      ],
    );
  }
}

class _TypeOfFishSection extends StatelessWidget {
  _TypeOfFishSection({
    @required this.title,
    @required this.attribute,
  });

  final String title;
  final String attribute;

  @override
  Widget build(BuildContext context) {
      return _DropDownMenuBuilder(
        title: title,
        attribute: attribute,
        items: FishStockList.values.map((fish) => describeEnum(fish)).toList(),
        isRequired: true,
      );
  }
}

class _DropDownMenuDatesBuilder extends StatelessWidget {
  _DropDownMenuDatesBuilder({
    @required this.title,
    @required this.attribute,
    @required this.items,
  });

  final String title;
  final String attribute;
  final List<DateTime> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: title),
        FormBuilderDropdown(
            name: attribute,
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child:
              Text('${DateFormat('E, d MMM yyyy').format(item)}'),
            )).toList())
      ],
    );

  }
}

class _DropDownMenuBuilder extends StatelessWidget {
  _DropDownMenuBuilder({
    @required this.title,
    @required this.attribute,
    @required this.items,
    this.isRequired = false,
  });

  final String title;
  final String attribute;
  final List<String> items;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: title),
        FormBuilderDropdown(
            name: attribute,
            validator: isRequired ? FormBuilderValidators.required(context) : null,
            items: items
                .map((item) => DropdownMenuItem(
                      value: ReCase(item).snakeCase,
                      child: Text(ReCase(item).titleCase),
                    ))
                .toList())
      ],
    );
  }
}

class _TemperatureSlider extends StatefulWidget {
  _TemperatureSlider({
    this.valueChanged,
    this.initialValue,
});

  final ValueChanged<double> valueChanged;
  final double initialValue;

  @override
  __TemperatureSliderState createState() => __TemperatureSliderState();
}

class __TemperatureSliderState extends State<_TemperatureSlider> {
  final controller = TextEditingController();
  double _currentValue;

  @override
  void initState() {
    _currentValue = widget.initialValue ?? 0;
    controller.text = '${_currentValue.toInt()}°C';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: 'Temperature'),
        Column(
          children: [
            FormBuilderSlider(
                name: CatchFormConstants.temperature,
                initialValue: _currentValue,
                divisions: 80,
                valueTransformer: (value) { return value.round(); },
                decoration: InputDecoration(
                  border: InputBorder.none
                ),
                displayValues: DisplayValues.none,
                activeColor: DSColors.green,
                inactiveColor: DSColors.pastelGreen,
                max: 40,
                min: -40,
                onChanged: (value) {
                  widget.valueChanged(value);
                  setState(() {
                    _currentValue = value;
                    controller.text = '${value.toInt()}°C';
                  });
                }
            ),
            Text(
              '${_currentValue.toInt()}°C',
              style: DesignSystemFonts.header,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ],
    );
  }
}

class _FishWeight extends StatelessWidget {
  _FishWeight({
    this.isRequired,
  });

  final bool isRequired;

  @override
  Widget build(BuildContext context) {

    List<FormFieldValidator<String>> _weightWholeValidators() {
      if (isRequired) {
        return [
          FormBuilderValidators.required(context, errorText: 'required'),
          FormBuilderValidators.numeric(context),
        ];
      } else {
        return [
          FormBuilderValidators.numeric(context),
        ];
      }
    }

     List<FormFieldValidator<String>> _weightFractionValidators() {
      if (isRequired) {
        return [
          FormBuilderValidators.numeric(context),
          FormBuilderValidators.max(context, 16),
        ];
      } else {
        return [
          FormBuilderValidators.numeric(context),
          FormBuilderValidators.max(context, 16),
        ];
      }
    }

    return Column(
      children: [
        DSComponents.header(text: 'Weight'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 75,
              child: FormBuilderTextField(
                name: CatchFormConstants.weightWhole,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(suffixText: 'Ib'),
                textAlign: TextAlign.center,
                validator: FormBuilderValidators.compose(_weightWholeValidators()),
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 50,
              height: 75,
              child: FormBuilderTextField(
                name: CatchFormConstants.weightFraction,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(suffixText: 'oz'),
                validator: FormBuilderValidators.compose(_weightFractionValidators()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CatchReportVisibility extends StatelessWidget {
  CatchReportVisibility({
    this.catchType,
    this.supportedCatchTypes,
    this.child,
});

final CatchType catchType;
final List<CatchType> supportedCatchTypes;
final Widget child;

 @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: supportedCatchTypes.contains(catchType),
      child: Column(
        children: [
          child,
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

enum CatchType {
  single,
  multi,
  match,
  missed
}