import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Image.asset('images/placeholders/achievements_screen.png', fit: BoxFit.fitWidth),
          constraints: BoxConstraints.expand(),
        ),
      ),
    );
  }
}
