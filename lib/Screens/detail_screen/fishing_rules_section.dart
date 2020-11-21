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

class FishingRulesListSection extends StatelessWidget {
  FishingRulesListSection(this.fishingRules);

  @required
  final List<String> fishingRules;

  Widget _rulesRow(String rule) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DSComponents.body(text: "- "),
            Expanded(child: DSComponents.body(text: rule))
          ],
        ),
        DSComponents.doubleSpacer(),
      ],
    );
  }

  Column _rulesColumn() {
    return Column(
      children: fishingRules.map((rule) => _rulesRow(rule)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
      return Container(
        child: Column(
          children: [
            DSComponents.header(text: 'Fishing Rules'),
            DSComponents.doubleSpacer(),
            _rulesColumn(),
          ],
        ),
      );
  }
}
