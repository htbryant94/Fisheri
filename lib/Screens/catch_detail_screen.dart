import 'package:fisheri/house_texts.dart';
import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CatchDetailScreen extends StatelessWidget {
  CatchDetailScreen({
    this.data,
  });

  final Catch data;
  
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
              TitleSection(
                title: '${data.catchType} Catch - ${data.typeOfFish}',
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: <Widget>[
                    HouseTexts.heading('Weight: ${convertGramsToPoundsAndOunces(data.weight)}'),
                    SizedBox(height: 16),
                    HouseTexts.heading('Time: ${data.time}'),
                    SizedBox(height: 16),
                    HouseTexts.heading('Date: ${formattedDate(data.date)}'),
                    SizedBox(height: 16),
                    HouseTexts.heading('Weather Condition: ${data.weatherCondition}'),
                    SizedBox(height: 16),
                    HouseTexts.heading('Wind Direction: ${data.windDirection}'),
                    SizedBox(height: 16),
                    HouseTexts.heading('Temperature: ${formattedTemperature(data.temperature)}'),
                    SizedBox(height: 16),
                    HouseTexts.heading('Notes: '),
                    SizedBox(height: 16),
                    Text(
                      '${data.notes}',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
