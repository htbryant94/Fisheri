import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Screens/detail_screen/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fisheri/house_colors.dart';
import 'package:intl/intl.dart';
import 'catch_form_screen.dart';
import 'package:fisheri/models/catch.dart';

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

class CatchFormScreenFull extends StatefulWidget {
  CatchFormScreenFull({
    @required this.dateRange,
    @required this.catchType,
    @required this.catchReportID,
  });

  final List<DateTime> dateRange;
  final CatchType catchType;
  final String catchReportID;

  @override
  _CatchFormScreenFullState createState() => _CatchFormScreenFullState();
}

class _CatchFormScreenFullState extends State<CatchFormScreenFull> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {

    dynamic _valueFor({String attribute}) {
      return _fbKey
          .currentState.fields[attribute].currentState.value;
    };

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Fisheri'),
        backgroundColor: HouseColors.primaryGreen,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
        children: <Widget>[
          Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                initialValue: {},
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    Header('${widget.catchType.name} Catch'),
                    SizedBox(height: 16),
                    _TypeOfFishSection(
                      title: 'Type of Fish *',
                      attribute: 'fish_type',
                      items: FisheriConstants.typesFish,
                      catchType: widget.catchType,
                    ),
                    SizedBox(height: 16),
                    _NumberOfFishSection(
                      isHidden: (widget.catchType.name != 'Multi'),
                    ),
                    SizedBox(height: 16),
                    _FishWeight(
                      isRequired: (widget.catchType.name != 'Multi'),
                    ),
                    SizedBox(height: 16),
                    _PositionSection(
                      title: 'Position',
                      attribute: 'position',
                      catchType: widget.catchType,
                    ),
                    SizedBox(height: 16),
                    _TimePickerBuilder(
                      title: 'Time',
                      attribute: 'time',
                      isHidden: (widget.catchType.name != 'Single'),
                    ),
                    SizedBox(height: 16),
                    _DropDownMenuDatesBuilder(
                      title: 'Date',
                      attribute: 'date',
                      items: widget.dateRange,
                      isHidden: (widget.catchType.name != 'Single'),
                    ),
                    SizedBox(height: 16),
                    _DropDownMenuBuilder(
                      title: 'Weather Conditions',
                      attribute: 'weather_condition',
                      items: FisheriConstants.weatherConditions,
                    ),
                    SizedBox(height: 16),
                    _DropDownMenuBuilder(
                      title: 'Wind Direction',
                      attribute: 'wind_direction',
                      items: FisheriConstants.windDirections,
                    ),
                    SizedBox(height: 16),
                    _TemperatureSlider(),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      attribute: "notes",
                      decoration: InputDecoration(
                          labelText: "Notes", border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 16),
                    Header('Add Photos - WIP'),
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

                          if (widget.catchType.name == 'Single') {
                            typeOfFish = _valueFor(attribute: CatchFormConstants.typeOfFish);
                            time = _valueFor(attribute: CatchFormConstants.time);
                            date = _valueFor(attribute: CatchFormConstants.date);
                          }
                          else if (widget.catchType.name == 'Multi') {
                            typeOfFish = _valueFor(attribute: CatchFormConstants.typeOfFish);
                            numberOfFish = _valueFor(attribute: CatchFormConstants.numberOfFish);
                          }
                          else if (widget.catchType.name == 'Match') {
                            position = _valueFor(attribute: CatchFormConstants.position);
                          }

                          catchModel = Catch(
                            catchType: widget.catchType.name,
                            catchReportID: widget.catchReportID,
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
    );
  }
}

class _NumberOfFishSection extends StatelessWidget {
  _NumberOfFishSection({
    this.isHidden = false,
});

  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return Container(width: 0, height: 0);
    } else {
      return Column(
        children: [
          Header('Number of Fish'),
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
}


class _PositionSection extends StatelessWidget {
  _PositionSection({
    @required this.title,
    @required this.attribute,
    @required this.catchType,
  });
  final String title;
  final String attribute;
  final CatchType catchType;

  @override
  Widget build(BuildContext context) {
    if (catchType.name == 'Match') {
      return Column(
        children: [
          Header(title),
          FormBuilderStepper(
            attribute: attribute,
            min: 0,
            max: 10,
          )
        ],
      );
    } else {
      return Container(height: 0, width: 0);
    }
  }
}

class _TimePickerBuilder extends StatelessWidget {
  _TimePickerBuilder({
    @required this.title,
    @required this.attribute,
    this.isHidden = false,
  });

  final String title;
  final String attribute;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return Container(height: 0, width: 0);
    } else {
      return Column(
        children: [
          Header(title),
          FormBuilderDateTimePicker(
            attribute: attribute,
            inputType: InputType.time,
          )
        ],
      );
    }
  }
}

class _TypeOfFishSection extends StatelessWidget {
  _TypeOfFishSection({
    @required this.title,
    @required this.attribute,
    @required this.items,
    @required this.catchType,
  });

  final String title;
  final String attribute;
  final List<String> items;
  final CatchType catchType;

  @override
  Widget build(BuildContext context) {
    if (catchType.name == 'Single' || catchType.name == 'Multi') {
      return _DropDownMenuBuilder(
        title: title,
        attribute: attribute,
        items: items,
        isRequired: true,
      );
    } else {
      return Container(width: 0, height: 0);
    }
  }
}

class _DropDownMenuDatesBuilder extends StatelessWidget {
  _DropDownMenuDatesBuilder({
    @required this.title,
    @required this.attribute,
    @required this.items,
    this.isHidden = false,
  });

  final String title;
  final String attribute;
  final List<DateTime> items;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
       return Container(height: 0, width: 0);
    } else {
      return Column(
        children: [
          Header(title),
          FormBuilderDropdown(
              attribute: attribute,
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child:
                Text('${DateFormat('E, d MMM yyyy').format(item)}'),
              ))
                  .toList())
        ],
      );
    }
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
        Header(title),
        FormBuilderDropdown(
            attribute: attribute,
            validators: isRequired ? [FormBuilderValidators.required()] : [],
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text('$item'),
                    ))
                .toList())
      ],
    );
  }
}

class _TemperatureSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header('Temperature'),
        FormBuilderSlider(
          attribute: 'temperature',
          initialValue: 20,
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
  });

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
        Header('Weight'),
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

  static const List<String> weatherConditions = [
    "Sunny",
    "Windy",
    "Rain",
    "Snow",
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
