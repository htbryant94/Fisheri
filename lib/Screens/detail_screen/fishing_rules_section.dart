import 'package:flutter/material.dart';
import 'header.dart';

class FishingRulesSection extends StatelessWidget {
  FishingRulesSection(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    if (content != null) {
      FlatButton readMoreButton = FlatButton(
        child: Text("Read More",
            style: TextStyle(
              color: Colors.blue,
            )),
      );

      Text textBody = Text(
        content,
        softWrap: true,
        overflow: TextOverflow.fade,
        maxLines: content != null ? 8 : 0,
      );
      return Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(children: [
            Header('Fishing Rules'),
            SizedBox(height: 16),
            textBody,
            readMoreButton
          ]));
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(children: [
          Header('Fishing Rules'),
          SizedBox(height: 16),
          Text("Couldn't retrieve information. Request the owner of this property to provide this data."),
        ]),
      );
    }
  }
}
