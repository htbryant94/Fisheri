import 'package:carousel_slider/carousel_controller.dart';
import 'package:fisheri/Screens/book_tickets_screen.dart';
import 'package:fisheri/Screens/detail_screen/contact_section.dart';
import 'package:fisheri/Screens/detail_screen/contents_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/Screens/detail_screen/social_media_section.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/holiday_detailed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/Screens/detail_screen/amenities_section.dart';
import 'package:fisheri/Screens/detail_screen/fish_stocked_section.dart';
import 'package:flutter/rendering.dart';

import 'detail_screen/fullscreen_image_carousel.dart';
import 'detail_screen/map_view_section.dart';

class HolidayDetailScreen extends StatefulWidget {
  HolidayDetailScreen({
    @required this.venue,
    this.imageURL,
  });

  final HolidayDetailed venue;
  final String imageURL;

  @override
  _HolidayDetailScreenState createState() => _HolidayDetailScreenState();
}

class _HolidayDetailScreenState extends State<HolidayDetailScreen> {
  List<String> sectionContents = [];
  int _currentImageCarouselIndex = 0;
  final _carouselController = CarouselController();

  bool hasSocialLinks() {
    return widget.venue.social.facebook != null && widget.venue.social.facebook.isNotEmpty ||
        widget.venue.social.twitter != null && widget.venue.social.twitter.isNotEmpty ||
        widget.venue.social.instagram != null && widget.venue.social.instagram.isNotEmpty ||
        widget.venue.social.youtube != null && widget.venue.social.youtube.isNotEmpty;
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

    sections.add(FishStockSectionFactory.standard(venue.fishStocked));
    sections.add(DSComponents.divider());

    if (venue.fishingRules != null) {
      sections.add(FishingRulesSection(fishingRules: venue.fishingRules));
      sections.add(DSComponents.divider());
    }

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
                  GestureDetector(
                    onTap: () {
                      Coordinator.present(
                          context,
                          showNavigationBar: false,
                          screen: FullscreenImageCarousel(
                            carouselController: _carouselController,
                            images: widget.venue.images,
                            initialIndex: _currentImageCarouselIndex,
                          )
                      );
                    },
                    child: ImageCarousel(
                      imageURLs: widget.venue.images,
                      index: _currentImageCarouselIndex,
                      controller: _carouselController,
                      height: 268,
                      indexChanged: (index) {
                        setState(() {
                          _currentImageCarouselIndex = index;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 24),
                    child: Column(children: buildSections(widget.venue)),
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
