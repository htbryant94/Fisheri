import 'package:fisheri/design_system.dart';
import 'package:flutter/cupertino.dart';

class Pill extends StatelessWidget {
  Pill({
    this.color,
    this.title,
    this.titleColor,
    this.icon
  });

  final Color color;
  final String title;
  final Color titleColor;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        height: 24,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: icon != null ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            DSComponents.halfSpacer(),
            DSComponents.bodySmall(text: title, color: titleColor, alignment: Alignment.center),
          ],
        ) : DSComponents.bodySmall(text: title, color: titleColor, alignment: Alignment.center)
    );
  }
}