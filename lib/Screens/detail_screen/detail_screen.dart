import 'package:fisheri/Components/form_fields/operational_hours_field.dart';
import 'package:fisheri/Screens/detail_screen/contact_section.dart';
import 'package:fisheri/Screens/detail_screen/contents_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/Screens/detail_screen/opening_hours_section.dart';
import 'package:fisheri/Screens/detail_screen/stats_section.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
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

    String _buildLocationString(List<String> items) {
      items.removeWhere((item) => item == null || item.isEmpty);
      return items.join(", ");
    }

    sections.add(TitleSection(
      title: venue.name,
      subtitle: _buildLocationString(
          [venue.address.street, venue.address.town, venue.address.postcode]),
    ));

    sections.add(DSComponents.doubleSpacer());

    sections.add(Row(
      children: [
        Icon(Icons.location_on, color: Colors.green, size: 20),
        DSComponents.halfSpacer(),
        DSComponents.body(text: '5.6 miles')
      ],
    ));

    sections.add(DSComponents.doubleSpacer());

    if (venue.categories != null) {
      sections.add(VenueCategoriesSection(
        categories: venue.categories,
        alwaysOpen: venue.alwaysOpen != null ? venue.alwaysOpen : false,
      ));
    }

    sections.add(DSComponents.paragraphSpacer());

    sections.add(DescriptionSection(
      text: venue.description,
    ));

    sections.add(DSComponents.paragraphSpacer());

    sections.add(ContentsSection(
      contents: [
        "Location",
        "Amenities",
        "Fishing Types",
        "Fish",
        "Rules",
        "Opening Hours"
      ],
    ));

    sections.add(DSComponents.paragraphSpacer());

    sections.add(StatsSection(
      stats: [
        Stat(name: "Catch Reports", value: 1247),
        Stat(name: "Upcoming Events", value: 2),
        Stat(name: "Check-Ins Today", value: 16),
      ],
    ));

    sections.add(DSComponents.divider());

    sections.add(MapViewSection(address: venue.address));

    sections.add(DSComponents.paragraphSpacer());

    sections.add(ContactSection(
      contactItems: [
        "Call",
        "Website",
        "Email",
      ],
    ));

    sections.add(DSComponents.divider());

    if (isLake()) {
      sections.add(AmenitiesSection(venue.amenities));
      sections.add(DSComponents.divider());
    }

    if (isLake()) {
      sections.add(FishStockedSection(venue.fishStocked));
      sections.add(DSComponents.divider());
    }

    sections.add(FishingTypesSection(
      title: 'Fishing Types & Tackles',
      fishTypes: venue.fishingTypes,
      fishTackles: venue.fishingTackles,
    ));

    sections.add(DSComponents.divider());

    if (isLake()) {
      sections.add(FishingRulesSection(venue.fishingRules));
    }

    sections.add(DSComponents.divider());

    sections.add(OpeningHoursSection(openingHours: venue.operationalHours));

    sections.add(DSComponents.sectionSpacer());

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ImageCarousel(
                    imageURLs: venue.images,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 24),
                    child: Column(children: buildSections(venue)),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 58,
                  padding: EdgeInsets.fromLTRB(52, 0, 52, 8),
                  alignment: Alignment.bottomCenter,
                  child: DSComponents.primaryButton(
                    text: "Book Tickets from £39",
                    onPressed: () { print("tapped"); }
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapViewSection extends StatelessWidget {
  MapViewSection({@required this.address});

  final VenueAddress address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: "Location"),
        DSComponents.paragraphSpacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 200,
          width: double.infinity,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('images/placeholders/lake_map_view.png',
                fit: BoxFit.cover),
            Image.asset('images/icons/map_marker_new.png'),
          ]),
        ),
        DSComponents.paragraphSpacer(),
        DSComponents.body(
            text: "${address.street}", alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(text: "${address.town}", alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(
            text: "${address.county}", alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(
            text: "${address.postcode}", alignment: Alignment.center),
      ],
    );
  }
}
