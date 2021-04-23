import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  ContactSection({
    this.contactDetails,
    this.websiteURL,
  });

  final ContactDetails contactDetails;
  final String websiteURL;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (contactDetails.phone != null)
          _ContactItem(
            name: 'Call',
            onPressed: () async  {
              print(contactDetails.phone);
              await launch('tel:${contactDetails.phone}');
            },
          ),
        if (websiteURL != null)
          _ContactItem(
            name: 'Website',
            onPressed: () async {
              await launch('https:$websiteURL');
            },
          ),
        if (contactDetails.email != null)
          _ContactItem(
            name: 'Email',
            onPressed: () async {
              print(contactDetails.email);
              await launch('mailto:${contactDetails.email}');
            },
          ),
      ]
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({
    this.name,
    this.onPressed,
  });

  final String name;
  VoidCallback onPressed;

  String _getImagePath(String name) {
    return 'images/icons/${ReCase(name).snakeCase}.png';
  }

  @override
  Widget build(BuildContext context) {
    return DSComponents.iconButton(
        image: Image.asset(_getImagePath(name)),
        backgroundColor: Colors.grey[100],
        highlightColor: DSColors.pastelGreen,
        onPressed: onPressed
    );
  }
}

