import 'package:flutter/material.dart';

class EventsCalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Image.asset('images/placeholders/events_calendar_main.png', fit: BoxFit.fitWidth),
          constraints: BoxConstraints.expand(),
        ),
      ),
    );
  }
}
