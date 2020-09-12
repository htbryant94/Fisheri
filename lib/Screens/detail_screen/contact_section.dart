import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class ContactSection extends StatelessWidget {
  ContactSection({
    this.contactItems,
  });

  final List<String> contactItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: contactItems.map((item) =>
          _ContactItem(name: item)
      ).toList()
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({
    this.name,
  });

  final String name;

  String _getImagePath(String name) {
    return "images/icons/${ReCase(name).snakeCase}.png";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(_getImagePath(name)),
        DSComponents.singleSpacer(),
        DSComponents.bodySmall(text: name, color: DSColors.black)
      ],
    );
  }
}

