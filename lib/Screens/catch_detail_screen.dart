import 'package:fisheri/house_texts.dart';
import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/house_colors.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:google_fonts/google_fonts.dart';

class CatchDetailScreen extends StatelessWidget {
  CatchDetailScreen({
    this.catchType,
    this.date,
    this.fishType,
    this.notes,
    this.temperature,
    this.time,
    this.weatherCondition,
    this.windDirection,
    this.weight,
  });

  final String catchType;
  final String date;
  final String fishType;
  final String notes;
  final double temperature;
  final String time;
  final String weatherCondition;
  final String windDirection;
  final double weight;

  String convertGramsToPoundsAndOunces(double grams) {
    if (grams != null) {
      double ounces = convertGramsToOunces(grams);
      int pounds = (ounces / 16).floor();
      int relativeOunces = (ounces % 16).floor();
      return "$pounds Ibs, $relativeOunces oz";
    }
    return "No information";
  }

  double convertGramsToOunces(double grams) {
    return grams / 28.34952;
  }

  String formattedTemperature(double temp) {
    if (temp != null) {
      return "${temp.toStringAsFixed(1)} °C";
    }
    return "No information";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Catch'),
          backgroundColor: HouseColors.primaryGreen,
        ),
        body: ListView(
          children: [
            ImageCarousel(),
            TitleSection(
              title: '$catchType Catch - $fishType',
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: <Widget>[
                  HouseTexts.heading('Weight: ${convertGramsToPoundsAndOunces(weight)}'),
                  SizedBox(height: 16),
                  HouseTexts.heading('Time: $time'),
                  SizedBox(height: 16),
                  HouseTexts.heading('Date: $date'),
                  SizedBox(height: 16),
                  HouseTexts.heading('Weather Condition: $weatherCondition'),
                  SizedBox(height: 16),
                  HouseTexts.heading('Wind Direction: $windDirection'),
                  SizedBox(height: 16),
                  HouseTexts.heading('Temperature: ${formattedTemperature(temperature)}'),
                  SizedBox(height: 16),
                  HouseTexts.heading('Notes: '),
                  SizedBox(height: 16),
                  Text(
                    '$notes',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
