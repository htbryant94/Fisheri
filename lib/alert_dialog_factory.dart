


import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';

class AlertDialogFactory {
  static AlertDialog invalidFormSubmission(BuildContext context) {
    return AlertDialog(
      title: DSComponents.header(text: 'There was a problem...'),
      content: SingleChildScrollView(
        child: DSComponents.body(
            text: 'Please correct any fields marked invalid and try again.'
        ),
      ),
      actionsPadding: EdgeInsets.all(8),
      actions: [
        DSComponents.primaryButton(
            text: 'OK',
            shadowEnabled: false,
            onPressed: () {
              Navigator.of(context).pop();
            }
        )
      ],
    );
  }

}