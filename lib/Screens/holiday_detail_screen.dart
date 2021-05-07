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

import 'detail_screen/map_view_section.dart';

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

    sections.add(
        MapViewSection(
          address: venue.address,
          coordinates: venue.coordinates,
        )
    );

    sections.add(DSComponents.paragraphSpacer());

    if (venue.websiteURL != null || venue.contactDetails != null) {
      sections.add(ContactSection(
        contactDetails: venue.contactDetails,
        websiteURL: venue.websiteURL,
      ));
      sections.add(DSComponents.divider());
    }

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
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.bottomCenter,
                  child: DSComponents.primaryButton(
                      text: 'Book Tickets from £39',
                      onPressed: () {
                        Coordinator.present(context, screenTitle: 'Tickets', screen: BookTicketsScreen());
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
