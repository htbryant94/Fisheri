import 'package:flutter/material.dart';

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
          Text(
            item,
            textAlign: TextAlign.center,
          )
        ]));
  }
}
