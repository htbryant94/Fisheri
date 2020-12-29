import 'package:fisheri/Screens/book_tickets_screen.dart';
import 'package:fisheri/Screens/detail_screen/contact_section.dart';
import 'package:fisheri/Screens/detail_screen/contents_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/Screens/detail_screen/social_media_section.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/holiday_detailed.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/Screens/detail_screen/amenities_section.dart';
import 'package:fisheri/Screens/detail_screen/fish_stocked_section.dart';
import 'package:flutter/rendering.dart';

class HolidayDetailScreen extends StatelessWidget {
  HolidayDetailScreen({
    @required this.venue,
    this.imageURL,
  });

  List<String> sectionContents = [];
  final HolidayDetailed venue;
  final String imageURL;

  bool hasSocialLinks() {
    return venue.social.facebook != null && venue.social.facebook.isNotEmpty ||
        venue.social.twitter != null && venue.social.twitter.isNotEmpty ||
        venue.social.instagram != null && venue.social.instagram.isNotEmpty ||
        venue.social.youtube != null && venue.social.youtube.isNotEmpty;
  }

  List<Widget> buildSections(HolidayDetailed venue) {
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
        "Opening Hours",
        "Social Media"
      ],
    ));

    sections.add(DSComponents.paragraphSpacer());

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

    sections.add(AmenitiesSection(venue.amenities));
    sections.add(DSComponents.divider());

    sections.add(FishStockSectionFactory.fromStringArray(venue.fishStocked));
    sections.add(DSComponents.divider());

    sections.add(FishingRulesSection(fishingRules: venue.fishingRules));
    sections.add(DSComponents.divider());

    sections.add(SocialMediaSection(social: venue.social));

    sections.add(DSComponents.sectionSpacer());
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
                      onPressed: () {
                        Coordinator.present(context, screenTitle: "Tickets", screen: BookTicketsScreen());
                      }
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
