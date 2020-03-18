import 'package:cached_network_image/cached_network_image.dart';

import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/material.dart';

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
    @required
    this.venue,
    this.imageURL,
    this.descriptionExpanded,
    this.index,
  });

  final VenueDetailed venue;
  final String imageURL;
  final bool descriptionExpanded;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ImageCarousel(
            imageURL: imageURL,
          ),
          TitleSection(
            title: venue.name,
            town: venue.address.town,
            county: venue.address.county,
          ),
          DescriptionSection(
            text: venue.description,
            descriptionExpanded: descriptionExpanded,
          ),
          SizedBox(height: 16),
          ButtonSection(Colors.blue),
          SizedBox(height: 16),
          FishStockedSection(venue.fishStocked),
          FishingTypesSection(venue.fishingTypes),
          AmenitiesSection(venue.amenities),
          TicketsSection(
            tickets: venue.tickets,
          ),
          OpeningHoursSection(
            openingHours: venue.operationalHours,
          ),
          FishingRulesSection(venue.fishingRules),
        ],
      ),
    );
  }
}
