import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../design_system.dart';
import '../touch_spin.dart';
import 'package:intl/intl.dart';

class FormBuilderTouchSpin extends StatelessWidget {
  FormBuilderTouchSpin({
    required this.attribute,
    required this.max,
    required this.min,
    this.step = 1,
    required this.title,
    this.validator,
    required this.value
  });

  final String attribute;
  final int max;
  final int min;
  final int step;
  final String title;
  final FormFieldValidator? validator;
  final num value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: title),
        DSComponents.doubleSpacer(),
        FormBuilderField(
          name: attribute,
          validator: validator,
          builder: (FormFieldState<dynamic> field) {
            return InputDecorator(
              decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.only(top: 10.0, bottom: 0.0),
                  border: InputBorder.none,
                  errorText: field.errorText
              ),
              child: TouchSpin(
                addIcon: Icon(Icons.add, color: DSColors.green),
                displayFormat: NumberFormat('0', 'en_US'),
                subtractIcon: Icon(Icons.remove, color: DSColors.green),
                max: 100,
                min: 1,
                onChanged: (value) {
                  field.didChange(value.toInt());
                },
                step: 1,
                value: value,
              ),
            );
          },
        ),
      ],
    );
  }
}