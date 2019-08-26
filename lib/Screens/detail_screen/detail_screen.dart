import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/fish_stock.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/button_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/Screens/detail_screen/amenities_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_types_section.dart';
import 'package:fisheri/Screens/detail_screen/fish_stocked_section.dart';
import 'package:fisheri/Screens/detail_screen/tickets_section.dart';
import 'package:fisheri/Screens/detail_screen/opening_hours_section.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    this.descriptionExpanded,
    this.title,
    this.descriptionText,
    this.fishStock,
    this.amenities,
    this.fishTypes,
    this.openingHours,
    this.address,
  });

  final bool descriptionExpanded;
  final String title;
  final String descriptionText;

  final List<dynamic> fishStock;
  final List<dynamic> amenities;
  final List<dynamic> fishTypes;
  final HoursOfOperation openingHours;
  final VenueAddress address;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ImageCarousel('images/lake.jpg'),
        TitleSection(
          title: title,
          town:  address.town,
          county: address.county,
        ),
        DescriptionSection(
          text: descriptionText,
          descriptionExpanded: descriptionExpanded,
        ),
        SizedBox(height: 16),
        ButtonSection(Colors.blue),
        SizedBox(height: 16),
        FishStockedSection(fishStock),
        FishingTypesSection(fishTypes),
        AmenitiesSection(amenities),
        TicketsSection(),
        OpeningHoursSection(
          openingHours: openingHours,
        ),
        FishingRulesSection(true),
      ],
    );
  }
}
