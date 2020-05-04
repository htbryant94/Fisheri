import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/foundation.dart';
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
import 'social_media_section.dart';
import 'package:flutter/rendering.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    @required this.venue,
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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCarousel(
                imageURLs: venue.images,
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
              SocialMediaSection(social: venue.social),
              MapViewSection(address: venue.address),
              ButtonSection(Colors.blue),
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
        ),
      ),
    );
  }
}

class MapViewSection extends StatelessWidget {
  MapViewSection({
    @required this.address
  });

  final VenueAddress address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          HouseTexts.heading('Map View'),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: Card(
              elevation: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'images/placeholders/lake_map_view.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 75,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HouseTexts.body(address.street),
                                HouseTexts.body('${address.town}, ${address.county}'),
                                HouseTexts.body(address.postcode),
                              ],
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              onPressed: () {
                                print('tapped');
                              },
                              child: Text('Directions', style: TextStyle(color: Colors.white),),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
