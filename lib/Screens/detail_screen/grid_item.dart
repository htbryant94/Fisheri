import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class GridItem extends StatelessWidget {
  GridItem({
    this.title,
    this.subtitle,
    this.image,
    this.width
  });

  final String title;
  final String subtitle;
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
          DSComponents.singleSpacer(),
          DSComponents.bodySmall(text: ReCase(title).titleCase, color: DSColors.black, alignment: Alignment.center),
          if(subtitle != null)
          DSComponents.bodySmall(text: subtitle, color: DSColors.grey, alignment: Alignment.center),
        ]));
  }
}
