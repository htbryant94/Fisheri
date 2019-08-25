import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
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
  DetailScreen(this.descriptionExpanded, this.title, this.fishStock,
      this.amenities, this.fishTypes);

  final bool descriptionExpanded;
  final String title;
  final List<dynamic> fishStock;
  final List<dynamic> amenities;
  final List<dynamic> fishTypes;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ImageCarousel('images/lake.jpg'),
        TitleSection(
          title: title,
          subtitle: 'Biggleswade, Hertfordshire',
        ),
        DescriptionSection(descriptionExpanded),
        ButtonSection(Colors.blue),
        SizedBox(height: 16),
        FishStockedSection(fishStock),
        FishingTypesSection(fishTypes),
        AmenitiesSection(amenities),
        TicketsSection(),
        OpeningHoursSection(),
        FishingRulesSection(true),
      ],
    );
  }
}
