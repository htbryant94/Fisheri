import 'package:flutter/material.dart';
import 'header.dart';

class FishingRulesSection extends StatelessWidget {
  FishingRulesSection(this.isExpanded);

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    FlatButton readMoreButton = FlatButton(
        child: Text("Read More", style: TextStyle(color: Colors.blue)),
        onPressed: () {
          print(isExpanded);
          // descriptionExpanded = !descriptionExpanded;
        });

    Text textBody = Text(
      'When and where you can fish National close season rules for coarse fishing apply across the Anglian region. The coarse fishing close season between 15 March and 15 June applies to all rivers, streams, drains, the Norfolk Broads and some stillwaters. Dates are inclusive All dates mentioned in these byelaws are inclusive: this means a stated period, such as 15 March to 15 June, includes the full day of 15 March and the full day of 15 June. Salmon and migratory trout The close season for salmon and migratory trout (in all waters) is 29 September to the last day of February. There is also a weekly close time from 6am on Sunday to midnight on the following day. A small number of rivers in Anglia have been canalised (converted into canals), and remain subject to the national close season: Fossdyke Canal, Louth Canal, Horncastle Canal and the Dilham and North Walsham Canal.',
      softWrap: true,
      overflow: TextOverflow.fade,
      maxLines: isExpanded ? 8 : 4,
    );

    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(children: [
          Header('Fishing Rules'),
          SizedBox(height: 16),
          textBody,
          readMoreButton
        ]));
  }
}