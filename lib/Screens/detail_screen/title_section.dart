import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  TitleSection({
    this.title,
    this.address,
  });

  final String title;
  final VenueAddress address;

  @override
  Widget build(BuildContext context) {

    String _buildLocationString(List<String> items) {
      items.removeWhere((item) => item == null || item.isEmpty);
      return items.join(", ");
    }

    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DSComponents.title(text: title),
            DSComponents.singleSpacer(),
            DSComponents.body(text: _buildLocationString([address.street, address.town, address.postcode]))
          ],
        ));
  }
}