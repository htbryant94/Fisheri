import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';

class DescriptionSection extends StatelessWidget {
  DescriptionSection({this.text, this.descriptionExpanded});

  final String text;
  final bool descriptionExpanded;

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          HouseTexts.heading('Description'),
          SizedBox(height: 16),
          HouseTexts.body(text),
        ]));
  }
}
