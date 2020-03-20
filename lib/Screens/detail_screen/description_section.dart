import 'package:flutter/material.dart';
import 'header.dart';
import 'package:google_fonts/google_fonts.dart';

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
        style: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          letterSpacing: 1,
        ),
//      overflow: TextOverflow.fade,
//      maxLines: descriptionExpanded ? 8 : 4,
    );

    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Header('Description'),
          SizedBox(height: 16),
          textBody,
//          readMoreButton
        ]));
  }
}
