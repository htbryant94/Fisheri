import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fisheri/Screens/venue_form_edit_screen.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/types/weather_condition.dart';
import 'package:fisheri/types/wind_direction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fisheri/models/catch.dart';
import 'package:recase/recase.dart';

class CatchFormScreenFull extends StatefulWidget {
  CatchFormScreenFull({
    @required this.dateRange,
    @required this.catchReportID,
  });

  final List<DateTime> dateRange;
  final String catchReportID;

  @override
  _CatchFormScreenFullState createState() => _CatchFormScreenFullState();
}

class _CatchFormScreenFullState extends State<CatchFormScreenFull> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final List<CatchType> catchTypes = CatchType.values;
  CatchType selectedCatchType;
  List<String> imageURLs = [];
  bool _isLoading = false;
  String _loadingText = 'Loading...';
  bool _didSetTemperature = false;

  @override
  Widget build(BuildContext context) {
    double _convertFishWeight({int whole, int fraction}) {
      return WeightConverter.poundsAndOuncesToGrams(pounds: whole, ounces: fraction);
    };

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
                        initialValue: {},
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          children: [
                            HouseTexts.heading('Catch Type'),
                            FormBuilderRadioGroup(
                              name: 'catch_type',
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
                                    attribute: 'fish_type',
                                  ),
                                ),
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.multi],
                              child: _NumberOfFishSection(),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: CatchType.values,
                              child: _FishWeight(
                                isRequired: (selectedCatchType != CatchType.multi),
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.match],
                              child: _PositionSection(
                                title: 'Position',
                                attribute: 'position',
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.single],
                              child: _TimePickerBuilder(
                                title: 'Time',
                                attribute: 'time',
                              ),
                            ),
                            CatchReportVisibility(
                              catchType: selectedCatchType,
                              supportedCatchTypes: [CatchType.single],
                              child: _DropDownMenuDatesBuilder(
                                title: 'Date',
                                attribute: 'date',
                                items: widget.dateRange,
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
                                    attribute: 'weather_condition',
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
                                attribute: 'wind_direction',
                                items: WindDirection.values.map((windDirection) => describeEnum(windDirection)).toList(),
                              ),
                            ),
                            CatchReportVisibility(
                                catchType: selectedCatchType,
                                supportedCatchTypes: CatchType.values,
                                child: _TemperatureSlider(
                                  valueChanged: (_) {
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
                                name: 'notes',
                                decoration: InputDecoration(
                                    labelText: 'Notes', border: OutlineInputBorder()),
                              ),
                            ),
                            FormBuilderImagePicker(
                              name: 'images',
                            ),
                            MaterialButton(
                              child: Text('Submit'),
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
                                  var _temperature;
                                  var _notes;

                                  if (_valueFor(attribute: CatchFormConstants.weightWhole) != null) {
                                    var _weightFraction = 0;

                                    if (_valueFor(attribute: CatchFormConstants.weightFraction) != null) {
                                      _weightFraction = int.parse(_valueFor(attribute: CatchFormConstants.weightFraction));
                                    }

                                    _weight = _convertFishWeight(
                                      whole: int.parse(_valueFor(attribute: CatchFormConstants.weightWhole)),
                                      fraction: _weightFraction
                                    );
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

                                  print('creating catch');

                                  catchModel = Catch(
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

                                  // 2. Upload catch to database
                                  final catchJSON = CatchJSONSerializer().toMap(catchModel);
                                  await FirebaseFirestore.instance
                                      .collection('catches')
                                      .add(catchJSON)
                                      .then((result) async {

                                    print('catch added successfully: ${result.id}');

                                    // 3. Upload images to storage
                                    if (_valueFor(attribute: 'images') != null) {
                                      print('uploading images');
                                      _updateLoadingMessage('Saving your Photos...');

                                      final _images = _valueFor(attribute: 'images');
                                      var index = 0;

                                      await Future.forEach(_images, (image) async {
                                        final storageReference = FirebaseStorage
                                            .instance
                                            .ref()
                                            .child('catch_reports/${widget.catchReportID}/${result.id}/$index');

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

                                    // 5. Amend database entry with imageURLs
                                    if (imageURLs.isNotEmpty) {
                                      print('amending Catch');

                                      catchModel.images = imageURLs;
                                      final amendedCatchJSON = CatchJSONSerializer().toMap(catchModel);

                                      await FirebaseFirestore.instance
                                          .collection('catches')
                                          .doc(result.id)
                                          .set(amendedCatchJSON)
                                          .whenComplete(() {
                                            _setLoadingState(false);
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
                                                    actions: [
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
                                    }

                                    _setLoadingState(false);
                                    await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Form successfully submitted'),
                                            content: SingleChildScrollView(
                                              child: Text(
                                                  'Tap Return to dismiss this page.'),
                                            ),
                                            actions: [
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
                                  await showDialog(
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
                                          actions: [
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.heading('Number of Fish'),
        FormBuilderTouchSpin(
          name: 'num_of_fish',
          initialValue: 0,
          min: 0,
          max: 100,
          step: 1,
        ),
      ],
    );
  }
}


class _PositionSection extends StatelessWidget {
  _PositionSection({
    @required this.title,
    @required this.attribute,
  });
  final String title;
  final String attribute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.heading(title),
        FormBuilderTouchSpin(
          name: attribute,
          initialValue: 1,
          min: 1,
          max: 10,
          step: 1,
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
        HouseTexts.heading(title),
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
        items: FishStock.values.map((fish) => describeEnum(fish)).toList(),
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
        HouseTexts.heading(title),
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
        HouseTexts.heading(title),
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

class _TemperatureSlider extends StatelessWidget {
  _TemperatureSlider({
    this.valueChanged
});

  final ValueChanged<double> valueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.heading('Temperature'),
        FormBuilderSlider(
          name: 'temperature',
          initialValue: 0,
          max: 40,
          min: -20,
          onChanged: valueChanged
        )
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
        HouseTexts.heading('Weight'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              child: FormBuilderTextField(
                name: 'fish_weight_whole',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(suffixText: 'Ib'),
                textAlign: TextAlign.center,
                validator: FormBuilderValidators.compose(_weightWholeValidators()),
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 50,
              child: FormBuilderTextField(
                name: 'fish_weight_fraction',
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

class CatchFormConstants {
  static const String typeOfFish = 'fish_type';
  static const String numberOfFish = 'num_of_fish';
  static const String position = 'position';
  static const String time = 'time';
  static const String date = 'date';
  static const String weightWhole = 'fish_weight_whole';
  static const String weightFraction = 'fish_weight_fraction';
  static const String weatherCondition = 'weather_condition';
  static const String windDirection = 'wind_direction';
  static const String temperature = 'temperature';
  static const String notes = 'notes';
}

enum CatchType {
  single,
  multi,
  match
}