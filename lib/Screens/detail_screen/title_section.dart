import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  TitleSection({
    this.title,
    this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DSComponents.title(text: title),
            DSComponents.singleSpacer(),
            if (subtitle != null)
              DSComponents.body(text: subtitle)
          ],
        ),
    );
  }
}