import 'package:flutter/material.dart';

import '../design_system.dart';

class SnackBarFactory {
  static void standard({BuildContext context, Widget content, int duration = 2}) {
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: content,
          duration: Duration(seconds: duration),
          backgroundColor: DSColors.green,
    ));
  }
}