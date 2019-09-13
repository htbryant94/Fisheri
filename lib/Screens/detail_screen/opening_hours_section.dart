import 'package:fisheri/models/hours_of_operation.dart';
import 'package:flutter/material.dart';
import 'header.dart';

class OpeningHoursSection extends StatelessWidget {
  OpeningHoursSection({
    this.openingHours,
  });

  final HoursOfOperation openingHours;

  @override
  Widget build(BuildContext context) {
    if(openingHours != null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(children: [
          Header('Opening Hours'),
          SizedBox(height: 16),
          _OpeningHoursRow(
            day: 'Monday',
            openTime: openingHours.monday.open,
            closeTime: openingHours.monday.close,
          ),
          _OpeningHoursRow(
            day: 'Tuesday',
            openTime: openingHours.tuesday.open,
            closeTime: openingHours.tuesday.close,
          ),
          _OpeningHoursRow(
            day: 'Wednesday',
            openTime: openingHours.wednesday.open,
            closeTime: openingHours.wednesday.close,
          ),
          _OpeningHoursRow(
            day: 'Thursday',
            openTime: openingHours.thursday.open,
            closeTime: openingHours.thursday.close,
          ),
          _OpeningHoursRow(
            day: 'Friday',
            openTime: openingHours.friday.open,
            closeTime: openingHours.friday.close,
          ),
          _OpeningHoursRow(
            day: 'Saturday',
            openTime: openingHours.saturday.open,
            closeTime: openingHours.saturday.close,
          ),
          _OpeningHoursRow(
            day: 'Sunday',
            openTime: openingHours.sunday.open,
            closeTime: openingHours.sunday.close,
          ),
        ]),
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(children: [
          Header('Opening Hours'),
          SizedBox(height: 16),
          Text("Couldn't retrieve information"),
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

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Text('$openTime - $closeTime'),
        ]);
  }
}
