import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';

class TitleSection extends StatelessWidget {
  TitleSection({
    this.title,
    this.town,
    this.county,
  });

  final String title;
  final String town;
  final String county;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HouseTexts.title(title),
            SizedBox(height: 8),
            if (town != null && county != null)
            HouseTexts.subtitle('$town, $county'),
          ],
        ));
  }
}