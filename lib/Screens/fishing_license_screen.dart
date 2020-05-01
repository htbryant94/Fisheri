import 'package:flutter/material.dart';

class FishingLicenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(child: Image.asset('images/placeholders/fishing_license.png', fit: BoxFit.fitWidth)),
      ),
    );
  }
}
