import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionSection extends StatelessWidget {
  DescriptionSection({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HouseTexts.heading('Overview'),
          SizedBox(height: 16),
          Row(children: [
            Icon(
              Icons.assignment,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            HouseTexts.body('1,247 catch reports')
          ]),
          SizedBox(height: 16),
          Row(children: [
            Icon(Icons.calendar_today, color: Colors.red),
            SizedBox(width: 8),
            HouseTexts.body('2 upcoming events')
          ]),
          SizedBox(height: 16),
          Row(children: [
            Icon(Icons.pin_drop, color: Colors.red),
            SizedBox(width: 8),
            HouseTexts.body('16 check-ins today'),
          ]),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              maxLines: 5,
              overflow: TextOverflow.fade,
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
