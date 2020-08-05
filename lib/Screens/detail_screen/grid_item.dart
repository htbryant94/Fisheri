import 'package:fisheri/house_texts.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fisheri/house_colors.dart';

class GridItem extends StatelessWidget {
  GridItem({this.item, this.image, this.width});

  final String item;
  final Image image;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: Column(children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: image,
          ),
          SizedBox(height: 8),
          HouseTexts.custom(text: item, alignment: Alignment.center, fontSize: 14),
        ]));
  }
}
