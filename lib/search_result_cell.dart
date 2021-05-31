import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/pill.dart';
import 'package:fisheri/Screens/venue_form_edit_screen.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Components/base_cell.dart';
import 'coordinator.dart';
import 'models/venue_detailed.dart';

import 'package:google_fonts/google_fonts.dart';

class VenueCategoriesSection extends StatelessWidget {
  VenueCategoriesSection({
    this.categories,
    this.alwaysOpen = false,
  });

  final List<dynamic> categories;
  final bool alwaysOpen;

  @override
  Widget build(BuildContext context) {

    if (alwaysOpen && !categories.contains("24/7")) {
      categories.add("24/7");
    }

    Color getTitleColorForCategory(String category) {
      if (category == "lake") {
        return DSColors.blue;
      } else if (category == "shop") {
        return DSColors.orange;
      } else if (category == "24/7") {
        return DSColors.green;
      }
      return Colors.grey;
    }

    Color getColorForCategory(String category) {
      if (category == "lake") {
        return DSColors.pastelBlue;
      } else if (category == "shop") {
        return DSColors.pastelOrange;
      } else if (category == "24/7") {
        return DSColors.pastelGreen;
      }
      return Colors.grey;
    }

    return Row(
      children: categories.asMap().entries.map((category) =>
      Row(
        children: [
          Pill(
            title: StringUtils.capitalize(category.value),
            titleColor: getTitleColorForCategory(category.value),
            color: getColorForCategory(category.value),
          ),
          DSComponents.singleSpacer(),
        ],
      )
      ).toList(),
    );
  }
}

class EditVenueCell extends StatelessWidget {
  EditVenueCell({
    @required this.venue,
    this.index,
  });

  final VenueSearch venue;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FirebaseFirestore.instance
              .collection('venues_detail')
              .doc(venue.id)
              .get()
              .then((DocumentSnapshot document) {
            final VenueDetailed _venue = VenueDetailedJSONSerializer().fromMap(document.data());
              Coordinator.push(context, screenTitle: "Edit Venue", screen: VenueFormEditScreen(venue: _venue, venueID: venue.id));
          });
        },
        child: RemoteImageBaseCell(
          title: venue.name,
          imageURL: venue.imageURL,
          height: 225,
          elements: <Widget>[
            DSComponents.bodySmall(text: venue.address.town),
            if (venue.categories != null)
              VenueCategoriesSection(categories: venue.categories, alwaysOpen: venue.alwaysOpen ?? false),
//            _VenueOperational(true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
//                if (venue.amenities != null)
//                  _VenueFeatures(features: venue.amenities),
//                SizedBox(width: 16),
//                _VenueDistance('5 miles')
              ],
            )
          ],
        ));
  }
}


class SearchResultCell extends StatelessWidget {
  SearchResultCell({
    @required this.venue,
    this.index,
    this.layout,
    this.distanceIndicator,
    this.userCurrentPosition,
  });

  final VenueSearch venue;
  final int index;
  final BaseCellLayout layout;
  final Widget distanceIndicator;
  final GeoPoint userCurrentPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FirebaseFirestore.instance
              .collection('venues_detail')
              .doc(venue.id)
              .get()
              .then((DocumentSnapshot document) {
            print('detail screen for venueID: ${venue.id}');
            final _venue = VenueDetailedJSONSerializer().fromMap(document.data());
            Coordinator.pushVenueDetailScreen(
                context,
                'Map',
                _venue,
                venue.imageURL,
                venue.id,
                userCurrentPosition,
            );
          });
        },
        child: RemoteImageBaseCell(
          title: venue.name,
          imageURL: venue.imageURL,
          height: layout == BaseCellLayout.cover ? 278 : 250,
          layout: layout,
          elements: <Widget>[
            DSComponents.singleSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DSComponents.bodySmall(text: venue.address.town),
                distanceIndicator
              ],
            ),
            DSComponents.singleSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (venue.categories != null)
                  VenueCategoriesSection(categories: venue.categories, alwaysOpen: venue.alwaysOpen ?? false),
                if (venue.amenities != null)
                  _VenueFeatures(features: venue.amenities),
//                if (venue.categories.contains('shop') && !venue.categories.contains('lake'))
//                  _VenueOperational(true),
//                SizedBox(width: 16),
              ],
            ),
          ],
        )
    );
  }
}

class _VenueOperational extends StatelessWidget {
  _VenueOperational(this.isOpen);

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${isOpen ? "Open" : "Closed"}',
      style: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: isOpen ? Colors.green : Colors.red,
      ),
    );
  }
}

class _VenueFeatures extends StatelessWidget {
  _VenueFeatures({this.features});

  final List<dynamic> features;

  @override
  Widget build(BuildContext context) {
    List<dynamic> limitedAmenities() {
      if (features.length > 5) {
        return features.sublist(0, 4);
      }
      return features;
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: limitedAmenities()
            .map((amenity) => Row(
                  children: [
                    Image.asset(
                      'images/icons/amenities/$amenity.png',
                      height: 20,
                      width: 20,
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                        print("couldn't load asset for $amenity");
                        return Text('😢');
                      }
                    ),
                    SizedBox(width: 8),
                  ],
                ))
            .toList());
  }
}

class _VenueDistance extends StatelessWidget {
  _VenueDistance(this.distance);

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$distance',
      style: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: Colors.black,
      ),
    );
  }
}
