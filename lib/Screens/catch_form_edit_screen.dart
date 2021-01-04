import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/house_texts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:fisheri/models/catch.dart';
import 'package:recase/recase.dart';

class FishWeight {
  FishWeight({
    this.pounds,
    this.ounces,
});

  final int pounds;
  final int ounces;
}

class CatchFormConstants {
  static const String typeOfFish = "fish_type";
  static const String numberOfFish = "num_of_fish";
  static const String position = "position";
  static const String time = "time";
  static const String date = "date";
  static const String weightWhole = "fish_weight_whole";
  static const String weightFraction = "fish_weight_fraction";
  static const String weatherCondition = "weather_condition";
  static const String windDirection = "wind_direction";
  static const String temperature = "temperature";
  static const String notes = "notes";
}

enum CatchType {
  single,
  multi,
  match
}

class CatchFormEditScreen extends StatefulWidget {
  CatchFormEditScreen({
    @required this.catchData
  });

  final Catch catchData;

  @override
  _CatchFormEditScreenState createState() => _CatchFormEditScreenState();
}

class _CatchFormEditScreenState extends State<CatchFormEditScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final List<CatchType> catchTypes = CatchType.values;
  CatchType selectedCatchType;

  dynamic _valueFor({String attribute}) {
    return _fbKey
        .currentState.fields[attribute].currentState.value;
  }

  CatchType catchTypeFromString(String string) {
    print(string);
    if (string == "single") {
      return CatchType.single;
    } else if (string == "multi") {
      return CatchType.multi;
    } else if (string == "match") {
      return CatchType.match;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCatchType = catchTypeFromString(widget.catchData.catchType);
  }

  @override
  Widget build(BuildContext context) {

    int _convertPoundsToOunces({int pounds}) {
      return pounds * 16;
    };

    double _convertOuncesToGrams({int ounces}) {
      return ounces * 28.34952;
    };

    double _convertPoundsAndOuncesToGrams({int pounds, int ounces}) {
      final int totalOunces = _convertPoundsToOunces(pounds: pounds) + ounces;
      return _convertOuncesToGrams(ounces: totalOunces);
    };

    double _convertFishWeight() {
      final String weightWhole = _valueFor(attribute: CatchFormConstants.weightWhole);
      final String weightFraction = _valueFor(attribute: CatchFormConstants.weightFraction);
      if (weightWhole.isNotEmpty  && weightFraction.isNotEmpty) {
        final int pounds = int.parse(weightWhole);
        final int ounces = int.parse(weightFraction);
        return _convertPoundsAndOuncesToGrams(pounds: pounds, ounces: ounces);
      }
      return null;
    };

    double convertGramsToOunces(double grams) {
      return grams / 28.34952;
    }

    FishWeight convertGramsToPoundsAndOunces(double grams) {
      if (grams != null) {
        double ounces = convertGramsToOunces(grams);
        int pounds = (ounces / 16).floor();
        int relativeOunces = (ounces % 16).floor();
        return FishWeight(pounds: pounds, ounces: relativeOunces);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
          children: <Widget>[
            Column(
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'catch_type': catchTypeFromString(widget.catchData.catchType),
                    'fish_weight_whole': '${convertGramsToPoundsAndOunces(widget.catchData.weight).pounds}',
                    'fish_weight_fraction': '${convertGramsToPoundsAndOunces(widget.catchData.weight).ounces}',
                    'fish_type': ReCase(widget.catchData.typeOfFish).titleCase,
                    'weather_condition': widget.catchData.weatherCondition,
                    'wind_direction': widget.catchData.windDirection,
                    'notes': widget.catchData.notes,
                  },
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      HouseTexts.heading('Catch Type'),
                      FormBuilderRadio(
                        attribute: 'catch_type',
                        options: catchTypes.map((type) => FormBuilderFieldOption(value: type, label: StringUtils.capitalize(describeEnum(type)))).toList(),
                        onChanged: (value) {
                          print("$value");
                          setState(() {
                            selectedCatchType = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      CatchReportVisibility(
                        catchType: selectedCatchType,
                        supportedCatchTypes: [CatchType.single, CatchType.multi],
                        child: _TypeOfFishSection(
                          title: 'Type of Fish *',
                          attribute: 'fish_type',
                          items: FisheriConstants.typesFish,
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
                          initialValue: widget.catchData.time != null ? DateFormat('HH:mm').parse(widget.catchData.time) : null,
                        ),
                      ),
                      CatchReportVisibility(
                        catchType: selectedCatchType,
                        supportedCatchTypes: CatchType.values,
                        child: _DropDownMenuBuilder(
                          title: 'Weather Conditions',
                          attribute: 'weather_condition',
                          items: WeatherCondition.values.map((condition) => describeEnum(condition)).toList()
                        ),
                      ),
                      CatchReportVisibility(
                        catchType: selectedCatchType,
                        supportedCatchTypes: CatchType.values,
                        child: _DropDownMenuBuilder(
                          title: 'Wind Direction',
                          attribute: 'wind_direction',
                          items: FisheriConstants.windDirections,
                        ),
                      ),
                      CatchReportVisibility(
                          catchType: selectedCatchType,
                          supportedCatchTypes: CatchType.values,
                          child: _TemperatureSlider(initialValue: widget.catchData.temperature),
                      ),
                      CatchReportVisibility(
                        catchType: selectedCatchType,
                        supportedCatchTypes: CatchType.values,
                        child: FormBuilderTextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: null,
                          attribute: "notes",
                          decoration: InputDecoration(
                              labelText: "Notes", border: OutlineInputBorder()),
                        ),
                      ),
                      HouseTexts.heading('Add Photos - WIP'),
                      MaterialButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if(_fbKey.currentState.validate()) {
                            Catch catchModel;
                            // COMMON
                            final double weight = _convertFishWeight();
                            String typeOfFish;

                            DateTime time;
                            final weatherCondition = _valueFor(attribute: CatchFormConstants.weatherCondition);
                            final windDirection = _valueFor(attribute: CatchFormConstants.windDirection);
                            final temperature = _valueFor(attribute: CatchFormConstants.temperature);
                            final notes = _valueFor(attribute: CatchFormConstants.notes);
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

                            catchModel = Catch(
                              catchType: describeEnum(selectedCatchType),
                              catchReportID: widget.catchData.catchReportID,
                              date: date != null ? date.toIso8601String() : null,
                              notes: notes,
                              numberOfFish: numberOfFish,
                              position: position != null ? position : null,
                              temperature: temperature,
                              time: time != null ? DateFormat('HH:mm').format(time) : null,
                              typeOfFish: typeOfFish,
                              weatherCondition: weatherCondition,
                              weight: weight,
                              windDirection: windDirection,
                            );
                            print('catch report successfully created:');
                            print('catchType: ${catchModel.catchType}');

                            final catchJSON = CatchJSONSerializer().toMap(catchModel);
                            Firestore.instance
                                .collection('catches')
                                .add(catchJSON)
                                .whenComplete(() {
                              print('catch added successfully');
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NumberOfFishSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.heading('Number of Fish'),
        FormBuilderStepper(
          attribute: "num_of_fish",
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
          attribute: attribute,
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
    this.initialValue,
  });

  final String title;
  final String attribute;
  final DateTime initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.heading(title),
        FormBuilderDateTimePicker(
          attribute: attribute,
          inputType: InputType.time,
          initialValue: initialValue,
        )
      ],
    );
  }
}

class _TypeOfFishSection extends StatelessWidget {
  _TypeOfFishSection({
    @required this.title,
    @required this.attribute,
    @required this.items,
  });

  final String title;
  final String attribute;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return _DropDownMenuBuilder(
      title: title,
      attribute: attribute,
      items: items,
      isRequired: true,
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
  final List<dynamic> items;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.heading(title),
        FormBuilderDropdown(
            attribute: attribute,
            validators: isRequired ? [FormBuilderValidators.required()] : [],
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text('${ReCase(item).titleCase}'),
            ))
                .toList())
      ],
    );
  }
}

class _TemperatureSlider extends StatelessWidget {
  _TemperatureSlider({
    this.initialValue,
});

  final double initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.heading('Temperature'),
        FormBuilderSlider(
          attribute: 'temperature',
          initialValue: initialValue ?? 0,
          max: 40,
          min: 0,
        )
      ],
    );
  }
}

class _FishWeight extends StatelessWidget {
  _FishWeight({
    this.isRequired,
    this.catchType,
    this.supportedCatchTypes,
  });

  final CatchType catchType;
  final List<CatchType> supportedCatchTypes;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {

    List<FormFieldValidator> _weightWholeValidators() {
      if (isRequired) {
        return [
          FormBuilderValidators.required(errorText: 'required'),
          FormBuilderValidators.numeric(),
        ];
      } else {
        return [
          FormBuilderValidators.numeric(),
        ];
      }
    }

    List<FormFieldValidator> _weightFractionValidators() {
      if (isRequired) {
        return [
          FormBuilderValidators.required(errorText: 'required'),
          FormBuilderValidators.numeric(),
          FormBuilderValidators.max(16),
        ];
      } else {
        return [
          FormBuilderValidators.numeric(),
          FormBuilderValidators.max(16),
        ];
      }
    }

    return Column(
      children: <Widget>[
        HouseTexts.heading('Weight'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              child: FormBuilderTextField(
                attribute: 'fish_weight_whole',
                decoration: InputDecoration(suffixText: 'Ib'),
                textAlign: TextAlign.center,
                validators: _weightWholeValidators(),

              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 50,
              child: FormBuilderTextField(
                attribute: 'fish_weight_fraction',
                decoration: InputDecoration(suffixText: 'oz'),
                validators: _weightFractionValidators(),
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

enum WeatherCondition {
  sunny,
  sunnyCloudy,
  cloudy,
  raining,
  rainingHeavy,
  thunderstorms,
  windy,
  snowing,
  night,
}

class FisheriConstants {
  static const List<String> typesFish = [
    "Crucian Carp",
    "Chub",
    "Roach",
    "Grass Carp",
    "Perch",
    "Rudd",
    "Rainbow Trout",
    "Brown Trout",
    "Salmon",
    "Koi Carp",
    "Grayling",
    "Zander",
    "Eel",
    "Orfe",
    "Dace",
    "Gudgeon",
    "Ruffe",
  ];

  static const List<String> windDirections = [
    "North",
    "North East",
    "North West",
    "East",
    "South",
    "South East",
    "South West",
    "West"
  ];
}
