import 'package:fisheri/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FishingRulesSection extends StatelessWidget {
  FishingRulesSection({
    this.fishingRules,
    this.limit = 5,
  });

  @required
  final List<String> fishingRules;
  final int limit;

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

  Column _rulesColumn({int limit}) {
    return Column(
        children: fishingRules
            .sublist(0, limit)
            .map((rule) => _rulesRow(rule))
            .toList());
  }

  int _getLimit() {
    return fishingRules.length < limit ? fishingRules.length : limit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DSComponents.header(text: 'Fishing Rules'),
          DSComponents.paragraphSpacer(),
          _rulesColumn(limit: _getLimit()),
          if (fishingRules.length > limit)
            CupertinoButton(
              child: DSComponents.body(text: 'More', color: DSColors.blue),
              onPressed: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        middle: Text('Fishing Rules'),
                      ),
                      backgroundColor: Colors.white,
                      child: SafeArea(
                        child: Scaffold(
                          body: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            controller: ModalScrollController.of(context),
                            child: _rulesColumn(limit: fishingRules.length)),
                        ),
                      ),
                      )
                    );
              },
            ),
        ],
      ),
    );
  }
}
