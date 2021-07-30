import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../design_system.dart';

class SnackBarFactory {
  static void standard({
    String title,
    String message,
    int duration = 3,
    SnackPosition position = SnackPosition.TOP,
    Color backgroundColor = DSColors.green
  }) {
    final primaryColor = Colors.white;
    final upIcon = Icon(Icons.keyboard_arrow_up, color: primaryColor, size: 32);
    final downIcon = Icon(Icons.keyboard_arrow_down, color: primaryColor, size: 32);

    Get.snackbar('', '',
      titleText: (title != null) ? DSComponents.title(text: title, color: primaryColor) : null,
      messageText: (message != null) ? DSComponents.subheaderSmall(text: message, color: primaryColor): null,
      duration: Duration(seconds: duration),
      backgroundColor: backgroundColor,
      icon: (position == SnackPosition.TOP) ? upIcon : downIcon,
      snackPosition: position
    );
  }
}