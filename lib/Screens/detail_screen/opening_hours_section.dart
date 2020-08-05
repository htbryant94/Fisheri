import 'package:fisheri/models/hours_of_operation.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';
import 'package:flutter/services.dart';

class OpeningHoursSection extends StatelessWidget {
  OpeningHoursSection({
    this.openingHours,
  });

  final HoursOfOperation openingHours;

  Widget _buildOpeningHoursRow({String day, OpeningHoursDay openingHours}) {
    return _OpeningHoursRow(
      day: day,
      openTime: openingHours != null ? openingHours.open : "Closed",
      closeTime: openingHours != null ? openingHours.close : "Closed",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (openingHours != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [
          HouseTexts.heading('Opening Hours'),
          SizedBox(height: 16),
          _buildOpeningHoursRow(day: 'Monday', openingHours: openingHours != null ? openingHours.monday : null),
          SizedBox(height: 8),
          _buildOpeningHoursRow(day: 'Tuesday', openingHours: openingHours != null ? openingHours.tuesday : null),
          SizedBox(height: 8),
          _buildOpeningHoursRow(day: 'Wednesday', openingHours: openingHours != null ? openingHours.wednesday : null),
          SizedBox(height: 8),
          _buildOpeningHoursRow(day: 'Thursday', openingHours: openingHours != null ? openingHours.thursday : null),
          SizedBox(height: 8),
          _buildOpeningHoursRow(day: 'Friday', openingHours: openingHours != null ? openingHours.friday : null),
          SizedBox(height: 8),
          _buildOpeningHoursRow(day: 'Saturday', openingHours: openingHours != null ? openingHours.saturday : null),
          SizedBox(height: 8),
          _buildOpeningHoursRow(day: 'Sunday', openingHours: openingHours != null ? openingHours.sunday : null),
          SizedBox(height: 8),
        ]),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [
          HouseTexts.heading('Opening Hours'),
          SizedBox(height: 16),
          HouseTexts.subheading("Couldn't retrieve information"),
        ]),
      );
    }
  }
}

class _OpeningHoursRow extends StatelessWidget {
  _OpeningHoursRow({this.day, this.openTime, this.closeTime});

  final String day;
  final String openTime;
  final String closeTime;

  Widget _timeInfo() {
    if (openTime == "Closed" || closeTime == "Closed") {
      return HouseTexts.custom(text: "Closed", color: Colors.red);
    } else if (openTime != null && closeTime != null) {
      return HouseTexts.custom(text:'$openTime - $closeTime', fontWeight: FontWeight.w400);
    } else {
      return HouseTexts.custom(text: 'Not Specified', color: Colors.black45);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      HouseTexts.body(day),
      _timeInfo(),
    ]);
  }
}
