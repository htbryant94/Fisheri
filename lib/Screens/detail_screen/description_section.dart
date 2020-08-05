import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';

class DescriptionSection extends StatelessWidget {
  DescriptionSection({this.text, this.descriptionExpanded});

  final String text;
  final bool descriptionExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          HouseTexts.heading('Overview'),
          SizedBox(height: 16),
          Row(children: [
            Icon(Icons.assignment, color: Colors.green,),
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
//          SizedBox(height: 16),
//          Row(children: [
//            Icon(Icons.star, color: Colors.blue),
//            Icon(Icons.star, color: Colors.blue),
//            Icon(Icons.star, color: Colors.blue),
//            Icon(Icons.star, color: Colors.blue),
//            Icon(Icons.star_half, color: Colors.blue),
//            SizedBox(width: 8),
//            HouseTexts.body('109 reviews')
//          ],
//          ),
          SizedBox(height: 16),
          HouseTexts.body(text),
        ],
      ),
    );
  }
}
