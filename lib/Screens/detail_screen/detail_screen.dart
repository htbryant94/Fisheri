import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/Screens/venue_form_edit_screen.dart';
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
import 'package:fisheri/Screens/detail_screen/tickets_section.dart';
import 'package:fisheri/Screens/detail_screen/opening_hours_section.dart';
import 'social_media_section.dart';
import 'package:flutter/rendering.dart';

class FisheriDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Divider(thickness: 0.5, indent: 24, endIndent: 24, color: DesignSystemColors.black.withOpacity(0.2)),
        SizedBox(height: 50),
      ],
    );
  }
}

class _DetailSection {
  _DetailSection({
    this.title,
    this.view,
  });

  final String title;
  final Widget view;
}

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
        ImageCarousel(
          imageURLs: venue.images,
        )
    );

    sections.add(
        TitleSection(
          title: venue.name,
          town: venue.address.town,
          county: venue.address.county,
        )
    );

    sections.add(
        Row(
          children: [
            Icon(Icons.pin_drop, color: Colors.green),
            Text('5.6 miles')
          ],
        )
    );

    if (venue.categories != null) {
      sections.add(
          VenueCategoriesSection(
            categories: venue.categories,
            alwaysOpen: venue.alwaysOpen != null ? venue.alwaysOpen : false,
          )
      );
    }

    sections.add(
        DescriptionSection(
          text: venue.description,
        )
    );

    sections.add(FisheriDivider());

    sections.add(MapViewSection(address: venue.address));

    sections.add(ButtonSection(Colors.grey));

    sections.add(FisheriDivider());

    if (isLake()) {
      sections.add(AmenitiesSection(venue.amenities));
      sections.add(FisheriDivider());
    }

    if (isLake()) {
      sections.add(FishStockedSection(venue.fishStocked));
      sections.add(FisheriDivider());
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
              children: buildSections(venue)
            ),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              ImageCarousel(
//                imageURLs: venue.images,
//              ),
//              TitleSection(
//                title: venue.name,
//                town: venue.address.town,
//                county: venue.address.county,
//              ),
//              if (venue.categories != null )
//              Padding(
//                padding: const EdgeInsets.only(left: 16),
//                child: VenueCategoriesSection(categories: venue.categories, alwaysOpen: venue.alwaysOpen != null ? venue.alwaysOpen : false),
//              ),
//                text: venue.description,
//              ),
//              DescriptionSection(
//              FisheriDivider(),
//              MapViewSection(address: venue.address),
//              ButtonSection(Colors.blue),
//              FisheriDivider(),
//              Visibility(
//                visible: isLake(),
//                child: AmenitiesSection(venue.amenities),
//              ),
//              FisheriDivider(),
//              Visibility(
//                visible: isLake(),
//                child: FishStockedSection(venue.fishStocked),
//              ),
////              FisheriDivider(),
////              Visibility(
////                visible: isLake(),
////                child: FishingRulesSection(venue.fishingRules),
////              ),
////              FisheriDivider(),
////              Visibility(
////                visible: venue.alwaysOpen != null ? !venue.alwaysOpen : true,
////                child: OpeningHoursSection(
////                  openingHours: venue.operationalHours,
////                ),
////              ),
////              FisheriDivider(),
////              Visibility(
////                visible: hasSocialLinks(),
////                child: SocialMediaSection(social: venue.social),
////              ),
//////              Visibility(
//////                visible: isLake(),
//////                child: FishingTypesSection(
//////                    title: 'Fishing Types',
//////                    fishTypes: venue.fishingTypes
//////                ),
//////              ),
//////              Visibility(
//////                visible: isShop(),
//////                child: FishingTypesSection(
//////                  title: 'Fishing Tackles Stocked',
//////                  fishTypes: venue.fishingTackles,
//////                ),
//////              ),
//////              Visibility(
//////                visible: isLake(),
//////                child: TicketsSection(
//////                  tickets: venue.tickets,
//////                ),
//////              ),
//            ],
//          ),
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
      ),
    );
  }
}
