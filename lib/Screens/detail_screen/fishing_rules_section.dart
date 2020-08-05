import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';

class FishingRulesSection extends StatelessWidget {
  FishingRulesSection(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    if (content != null && content.isNotEmpty) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            HouseTexts.heading('Fishing Rules'),
            SizedBox(height: 16),
            textBody,
            readMoreButton
          ]));
    } else {
      return Container();
    }
  }
}
