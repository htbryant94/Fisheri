import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

class HolidayCountriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Wrap(
        children: [
          _FlagItem('france'),
          _FlagItem('croatia'),
          _FlagItem('belgium'),
          _FlagItem('netherlands'),
          _FlagItem('spain'),
          _FlagItem('germany'),
        ],
      ),
    )));
  }
}

class _FlagItem extends StatelessWidget {
  _FlagItem(this.flag);

  final String flag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('images/flags/$flag.png',
            width: MediaQuery.of(context).size.width / 2),
        Text(StringUtils.capitalize(flag)),
      ],
    );
  }
}
