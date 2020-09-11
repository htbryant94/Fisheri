import 'package:fisheri/design_system.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/button_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/Screens/detail_screen/amenities_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_types_section.dart';
import 'package:fisheri/Screens/detail_screen/fish_stocked_section.dart';
import 'package:flutter/rendering.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    @required this.venue,
    this.imageURL,
    this.index,
  });

  List<String> sectionContents = [];
  final VenueDetailed venue;
  final String imageURL;
  final int index;
  
  bool isLake() {
    return venue.categories.contains('lake');
  }

  bool isShop() {
    return venue.categories.contains('shop');
  }

  bool hasSocialLinks() {
    return venue.social.facebook != null && venue.social.facebook.isNotEmpty ||
        venue.social.twitter != null && venue.social.twitter.isNotEmpty ||
        venue.social.instagram != null && venue.social.instagram.isNotEmpty ||
        venue.social.youtube != null && venue.social.youtube.isNotEmpty;
  }

  List<Widget> buildSections(VenueDetailed venue) {
    List<Widget> sections = [];

    sections.add(
        TitleSection(
          title: venue.name,
          town: venue.address.town,
          county: venue.address.county,
        )
    );

    sections.add(DSComponents.singleSpacer());

    sections.add(
        Row(
          children: [
            Icon(Icons.pin_drop, color: Colors.green),
            Text('5.6 miles')
          ],
        )
    );

    sections.add(DSComponents.singleSpacer());

    if (venue.categories != null) {
      sections.add(
          VenueCategoriesSection(
            categories: venue.categories,
            alwaysOpen: venue.alwaysOpen != null ? venue.alwaysOpen : false,
          )
      );
    }

    sections.add(DSComponents.singleSpacer());

    sections.add(
        DescriptionSection(
          text: venue.description,
        )
    );

    sections.add(DSComponents.divider());

    sections.add(MapViewSection(address: venue.address));

    sections.add(DSComponents.doubleSpacer());

    sections.add(ButtonSection(Colors.grey));

    sections.add(DSComponents.divider());

    if (isLake()) {
      sections.add(AmenitiesSection(venue.amenities));
      sections.add(DSComponents.divider());
    }

    if (isLake()) {
      sections.add(FishStockedSection(venue.fishStocked));
      sections.add(DSComponents.divider());
    }

    sections.add(
        FishingTypesSection(
          title: 'Fishing Types & Tackles',
          fishTypes: venue.fishingTypes,
          fishTackles: venue.fishingTackles,
        )
    );

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Column(
              children:[
                ImageCarousel(
                  imageURLs: venue.images,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                  child: Column(
                    children: buildSections(venue)
                  ),
                ),
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
    return Column(
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
                Padding(
                  padding: EdgeInsets.only(top: 8, right: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        print('tapped');
                        },
                      child: Text('Directions', style: TextStyle(color: Colors.white),
                      ),
                    ),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
