import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';

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
        child: Column(
          children: [
            DSComponents.header(text: 'Opening Hours'),
            DSComponents.doubleSpacer(),
            _buildOpeningHoursRow(
                day: 'Monday', openingHours: openingHours.monday),
            DSComponents.singleSpacer(),
            _buildOpeningHoursRow(
                day: 'Tuesday', openingHours: openingHours.tuesday),
            DSComponents.singleSpacer(),
            _buildOpeningHoursRow(
                day: 'Wednesday', openingHours: openingHours.wednesday),
            DSComponents.singleSpacer(),
            _buildOpeningHoursRow(
                day: 'Thursday', openingHours: openingHours.thursday),
            DSComponents.singleSpacer(),
            _buildOpeningHoursRow(
                day: 'Friday', openingHours: openingHours.friday),
            DSComponents.singleSpacer(),
            _buildOpeningHoursRow(
                day: 'Saturday', openingHours: openingHours.saturday),
            DSComponents.singleSpacer(),
            _buildOpeningHoursRow(
                day: 'Sunday', openingHours: openingHours.sunday),
            DSComponents.singleSpacer(),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(children: [
          DSComponents.header(text: 'Opening Hours'),
          DSComponents.doubleSpacer(),
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
      return DSComponents.body(text: "Closed");
    } else if (openTime != null && closeTime != null) {
      return DSComponents.body(text: '$openTime - $closeTime');
    } else {
      return DSComponents.body(text: 'Not Specified');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DSComponents.body(text: day),
        DSComponents.doubleSpacer(),
        _timeInfo(),
      ],
    );
  }
}
