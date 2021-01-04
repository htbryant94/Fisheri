import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class CatchDetailScreen extends StatelessWidget {
  CatchDetailScreen({
    this.data,
  });

  final Catch data;
//
//  String convertGramsToPoundsAndOunces(double grams) {
//    if (grams != null) {
//      double ounces = convertGramsToOunces(grams);
//      int pounds = (ounces / 16).floor();
//      int relativeOunces = (ounces % 16).floor();
//      return "$pounds Ibs, $relativeOunces oz";
//    }
//  }
//
//  double convertGramsToOunces(double grams) {
//    return grams / 28.34952;
//  }

  String formattedTemperature(double temp) {
    if (temp != null) {
      return "${temp.toStringAsFixed(1)} °C";
    }
    return "No information";
  }

  String formattedDate(String date) {
    return date != null
        ? DateFormat('EEEE, MMM d, yyyy')
        .format(DateTime.parse(date))
        : "No Date";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              ImageCarousel(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: <Widget>[
                    TitleSection(
                      title: '${ReCase(data.catchType).titleCase} Catch - ${ReCase(data.typeOfFish).titleCase}',
                    ),
                    if (data.weight != null)
                    _DetailRow(name: 'Weight', value: WeightConverter.gramsToPoundsAndOunces(data.weight)),
                    if (data.time != null)
                    _DetailRow(name: 'Time', value: data.time),
                    if (data.date != null)
                    _DetailRow(name: 'Date', value: formattedDate(data.date)),
                    if (data.weatherCondition != null)
                    _DetailRow(name: 'Weather Condition', value: ReCase(data.weatherCondition).titleCase),
                    if (data.windDirection != null)
                    _DetailRow(name: 'Wind Direction', value: ReCase(data.windDirection).titleCase),
                    if (data.temperature != null)
                    _DetailRow(name: 'Temperature', value: formattedTemperature((data.temperature))),
                    HouseTexts.subheading('Notes:'),
                    SizedBox(height: 16),
                    HouseTexts.body(data.notes),
                    SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class _DetailRow extends StatelessWidget {
  _DetailRow({
    this.name,
    this.value,
});

  final String name;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HouseTexts.subheading('$name:'),
            DSComponents.singleSpacer(),
            HouseTexts.heading('$value'),
          ],
        ),
        DSComponents.doubleSpacer()
      ],
    );
  }
}
