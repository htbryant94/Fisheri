import 'package:flutter/material.dart';
import 'header.dart';

class OpeningHoursSection extends StatelessWidget {
  OpeningHoursSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Column(children: [
        Header('Opening Hours'),
        SizedBox(height: 16),
        _OpeningHoursRow('Monday', '09:00', '22:00'),
        _OpeningHoursRow('Tuesday', '09:00', '22:00'),
        _OpeningHoursRow('Wednesday', '09:00', '22:00'),
        _OpeningHoursRow('Thursday', '09:00', '22:00'),
        _OpeningHoursRow('Friday', '09:00', '22:00'),
        _OpeningHoursRow('Saturday', '09:00', '22:00'),
        _OpeningHoursRow('Sunday', '09:00', '22:00'),
      ]),
    );
  }
}

class _OpeningHoursRow extends StatelessWidget {
  _OpeningHoursRow(this.day, this.openTime, this.closeTime);

  final String day;
  final String openTime;
  final String closeTime;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(day),
          Text('$openTime - $closeTime'),
        ]);
  }
}
