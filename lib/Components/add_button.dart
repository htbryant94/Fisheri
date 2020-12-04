import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../design_system.dart';

class AddButton extends StatelessWidget {
  AddButton({
    this.title,
    this.onPressed,
});

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Container(
            child: Icon(Icons.add, color: Colors.white),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DSColors.green,
            ),
          ),
          SizedBox(width: 8),
          DSComponents.subheader(text: title),
        ],
      ),
    );
  }
}