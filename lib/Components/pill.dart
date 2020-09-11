import 'package:fisheri/design_system.dart';
import 'package:flutter/cupertino.dart';

class Pill extends StatelessWidget {
  Pill({this.color, this.title, this.titleColor});

  final Color color;
  final String title;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: DSComponents.bodySmall(text: title, color: titleColor, alignment: Alignment.center)
    );
  }
}