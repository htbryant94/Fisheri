


import 'package:fisheri/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogFactory {

  static AlertDialog generic({
    BuildContext context,
    String title = 'There was a problem...',
    String message
  }) {
    return AlertDialog(
      title: DSComponents.header(text: title),
      content: SingleChildScrollView(
        child: DSComponents.body(text: message),
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

  static AlertDialog deleteConfirmation({
    BuildContext context,
    VoidCallback onDeletePressed
  }) {
    return AlertDialog(
      title: DSComponents.header(
        text: 'Are you sure?',
      ),
      content: SingleChildScrollView(
        child: DSComponents.body(
            text: 'This action will remove all data including any images and cannot be reverted.'
        ),
      ),
      actions: [
        CupertinoButton(
          child: DSComponents.body(
            text: 'Delete',
            color: Colors.red,
          ),
          onPressed: onDeletePressed,
        ),
        CupertinoButton(
          child: DSComponents.body(
            text: 'Cancel',
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}