// @dart=2.9

import 'package:flutter/material.dart';

class CreateEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Image.asset('images/placeholders/events_calendar_create.png', fit: BoxFit.fitWidth)
          )
        ),
    );
  }
}
