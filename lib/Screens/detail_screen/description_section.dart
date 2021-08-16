// @dart=2.9

import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  DescriptionSection({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DSComponents.body(text: text)
        ],
      ),
    );
  }
}
