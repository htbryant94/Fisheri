import 'package:flutter/material.dart';
import 'header.dart';

class DescriptionSection extends StatelessWidget {
  DescriptionSection({this.text, this.descriptionExpanded});

  final String text;
  final bool descriptionExpanded;

  @override
  Widget build(BuildContext context) {
    FlatButton readMoreButton = FlatButton(
        child: Text("Read More", style: TextStyle(color: Colors.blue)),
        onPressed: () {
          print(descriptionExpanded);
          // descriptionExpanded = !descriptionExpanded;
        });

    Text textBody = Text(
      text,
      softWrap: true,
//      overflow: TextOverflow.fade,
//      maxLines: descriptionExpanded ? 8 : 4,
    );

    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(children: [
          Header('Description'),
          SizedBox(height: 16),
          textBody,
//          readMoreButton
        ]));
  }
}
