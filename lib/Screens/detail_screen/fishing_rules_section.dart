import 'package:fisheri/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FishingRulesSection extends StatelessWidget {
  FishingRulesSection(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    if (content != null && content.isNotEmpty) {
      return Container(
        child: Column(
          children: [
            DSComponents.header(text: 'Fishing Rules'),
            DSComponents.doubleSpacer(),
            DSComponents.body(text: content, maxLines: 8),
            CupertinoButton(
              child: DSComponents.body(text: 'More', color: DSColors.blue),
              onPressed: () {
              },
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
