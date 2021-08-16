// @dart=2.9

import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/distance_indicator.dart';
import 'package:fisheri/Components/fisheri_icon_button.dart';
import 'package:fisheri/Screens/book_tickets_screen.dart';
import 'package:fisheri/Screens/detail_screen/contact_section.dart';
import 'package:fisheri/Screens/detail_screen/contents_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/Screens/detail_screen/fullscreen_image_carousel.dart';
import 'package:fisheri/Screens/detail_screen/opening_hours_section.dart';
import 'package:fisheri/Screens/detail_screen/social_media_section.dart';
import 'package:fisheri/Screens/detail_screen/stats_section.dart';
import 'package:fisheri/Screens/detail_screen/swims_list_view.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
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
import 'package:panorama/panorama.dart';

import 'map_view_section.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    @required this.venue,
    this.imageURL,
    this.index,
    this.id,
    this.userCurrentLocation,
  });

  final VenueDetailed venue;
  final String imageURL;
  final int index;
  final String id;
  final GeoPoint userCurrentLocation;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> sectionContents = [];
  int _currentImageCarouselIndex = 0;
  final _carouselController = CarouselController();

  final _swimsData = [
    PanoramaItem(name: 'Car-park Bay', imageURL: 'images/placeholders/swims/swim_1.jpg'),
    PanoramaItem(name: 'Narrow Point', imageURL: 'images/placeholders/swims/swim_2.jpg'),
    PanoramaItem(name: 'Right-hand Bank', imageURL: 'images/placeholders/swims/swim_3.jpg'),
    PanoramaItem(name: 'A1 Bay', imageURL: 'images/placeholders/swims/swim_4.jpg'),
    PanoramaItem(name: 'Overgrown', imageURL: 'images/placeholders/swims/swim_5.jpg'),
    PanoramaItem(name: 'Far Bay', imageURL: 'images/placeholders/swims/swim_6.jpg'),
  ];

  final _shopData = [
    PanoramaItem(name: null, imageURL: 'images/placeholders/shops/Waltham_Cross_1.jpg'),
    PanoramaItem(name: null, imageURL: 'images/placeholders/shops/Waltham_Cross_2.jpg'),
    PanoramaItem(name: null, imageURL: 'images/placeholders/shops/Waltham_Cross_3.jpg'),
    PanoramaItem(name: null, imageURL: 'images/placeholders/shops/Waltham_Cross_4.jpg'),
    PanoramaItem(name: null, imageURL: 'images/placeholders/shops/Waltham_Cross_5.jpg'),
  ];

  bool hasValue(dynamic value) {
    return value != null && value.isNotEmpty;
  }

  bool hasSocialMedia(Social socialMedia) {
    return socialMedia.facebook != null ||
    socialMedia.instagram != null ||
    socialMedia.twitter != null ||
    socialMedia.youtube != null;
  }

  bool isLake() {
    return widget.venue.categories.contains('lake');
  }

  bool isShop() {
    return widget.venue.categories.contains('shop');
  }

  bool canShowBookNowButton() {
    return false;
    // return widget.venue.tickets != null && widget.venue.tickets.contains('day');
  }

  bool canShowJoinWaitingListButton() {
    return false;
    // return !canShowBookNowButton() &&
    //     widget.venue.tickets != null &&
    //     (widget.venue.tickets.contains('season') || widget.venue.tickets.contains('syndicate') || widget.venue.tickets.contains('club_water'));
  }

  bool hasSocialLinks() {
    return widget.venue.social.facebook != null && widget.venue.social.facebook.isNotEmpty ||
        widget.venue.social.twitter != null && widget.venue.social.twitter.isNotEmpty ||
        widget.venue.social.instagram != null && widget.venue.social.instagram.isNotEmpty ||
        widget.venue.social.youtube != null && widget.venue.social.youtube.isNotEmpty;
  }

  bool canShowSwims() {
    return widget.id == 'O2HrBE1LqynNfXN2AvHX'; // Manor Farm Lakes
  }

  bool canShowShops() {
    return widget.id == 'PAgCOwaht3K6wJqUo6fo'; // Angling Direct Chelmsford
  }

  List<Widget> buildSections(BuildContext context, VenueDetailed venue) {
    List<Widget> sections = [];

    String _buildLocationString(List<String> items) {
      items.removeWhere((item) => item == null || item.isEmpty);
      return items.join(', ');
    }

    sections.add(TitleSection(
      title: venue.name,
      subtitle: _buildLocationString(
          [venue.address.street, venue.address.town, venue.address.postcode]),
    ));

    sections.add(DSComponents.doubleSpacer());

    if (venue.coordinates != null && widget.userCurrentLocation != null) {
      sections.add(
          DistanceIndicator(
            selectedVenueLocation: venue.coordinates,
            userCurrentLocation: widget.userCurrentLocation,
          )
      );
      sections.add(DSComponents.doubleSpacer());
    }

    if (venue.categories != null) {
      sections.add(VenueCategoriesSection(
        categories: venue.categories,
        alwaysOpen: venue.alwaysOpen != null ? venue.alwaysOpen : false,
      ));
    }

    sections.add(DSComponents.paragraphSpacer());

    if (canShowSwims()) {
      sections.add(PanoramaRail(title: 'Swims', items: _swimsData));
      sections.add(DSComponents.divider());
    }

    if (canShowShops()) {
      sections.add(PanoramaRail(title: 'Gallery', items: _shopData));
      sections.add(DSComponents.divider());
    }

    sections.add(DescriptionSection(
      text: venue.description,
    ));

    // sections.add(DSComponents.doubleSpacer());
    // sections.add(DSComponents.subheaderSmall(text: 'ID: ${widget.id}', alignment: Alignment.centerLeft));

    sections.add(DSComponents.paragraphSpacer());

    sections.add(ContentsSection(
      contents: [
        'Location',
        if (hasValue(venue.amenities))
        'Amenities',
        if (hasValue(venue.fishingTypes))
        'Fishing Types',
        if (hasValue(venue.fishStock))
        'Fish',
        if (hasValue(venue.fishingRules))
        'Rules',
        if (venue.operationalHours != null)
        'Opening Hours',
        if (hasSocialMedia(venue.social))
        'Social Media',
      ],
    ));

    // sections.add(DSComponents.paragraphSpacer());
    //
    // sections.add(StatsSection(
    //   stats: [
    //     if (isLake())
    //     Stat(name: 'Catch Reports', value: 1247),
    //     Stat(name: 'Upcoming Events', value: 2),
    //     Stat(name: 'Check-Ins Today', value: 16),
    //   ],
    // ));

    sections.add(DSComponents.divider());

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

    if (isLake()) {
      sections.add(AmenitiesSection(venue.amenities));
      sections.add(DSComponents.divider());
    }

    if (isLake()) {
      if (venue.fishStock != null) {
        sections.add(FishStockSectionFactory.standard(venue.fishStock));
      } else {
        sections.add(FishStockSectionFactory.fromStringArray(venue.fishStocked));
      }
      sections.add(DSComponents.divider());
    }

    if(venue.fishingTackles != null || venue.fishingTypes != null) {
      sections.add(FishingTypesSection(
        title: 'Fishing Types & Tackle',
        fishTypes: venue.fishingTypes,
        fishTackles: venue.fishingTackles,
      ));
      sections.add(DSComponents.divider());
    }

    if (isLake() && venue.fishingRules != null && venue.fishingRules.isNotEmpty) {
      final fishingRulesList = venue.fishingRules.split('*');
      fishingRulesList.removeAt(0);
      sections.add(FishingRulesSection(fishingRules: fishingRulesList));
      sections.add(DSComponents.divider());
    }

    sections.add(OpeningHoursSection(openingHours: venue.operationalHours));

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
                  Stack(
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                    child: Column(children: buildSections(context, widget.venue)),
                  ),
                ],
              ),
            ),
            if (canShowBookNowButton())
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: DSComponents.primaryButton(
                    text: 'Book Tickets from £39',
                    onPressed: () {
                      Coordinator.present(context, screenTitle: 'Tickets', screen: BookTicketsScreen());
                    }
                  )
              ),
            ),
            if (canShowJoinWaitingListButton())
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: DSComponents.primaryButton(
                        text: 'Join Waiting List',
                        onPressed: () {
                          Coordinator.present(context, screenTitle: 'Tickets', screen: BookTicketsScreen());
                        }
                    )
                ),
              ),
            Positioned(
                top: 16,
                left: 16,
                child: FisheriIconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: 32),
                  onTap:  Navigator.of(context).pop,
                )
            ),
          ],
        ),
      ),
    );
  }
}

class ThreeSixtyImageButton extends StatelessWidget {
  const ThreeSixtyImageButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(
        'images/icons/360-degrees.png',
        color: Colors.white,
        height: 32,
        width: 32,
      ),
      onTap: () {
        Coordinator.present(
            context,
            screenTitle: '360° View',
            screen: Panorama(
              child: Image.asset('images/placeholders/panorama2.jpg'),
            )
        );
      },
    );
  }
}
