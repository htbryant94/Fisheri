import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Components/base_cell.dart';
import 'coordinator.dart';
import 'models/venue_detailed.dart';

import 'package:google_fonts/google_fonts.dart';

class SearchResultCell extends StatelessWidget {
  SearchResultCell({
    @required this.venue,
    this.index,
  });

  final VenueSearch venue;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Firestore.instance
              .collection('venues_detail')
              .document(venue.id)
              .get()
              .then((DocumentSnapshot document) {
            final _venue = VenueDetailedJSONSerializer().fromMap(document.data);
            Coordinator.pushVenueDetailScreen(
                context, 'Map', _venue, venue.imageURL);
          });
        },
        child: RemoteImageBaseCell(
          title: venue.name,
          subtitle: 'TODO',
          imageURL: venue.imageURL,
          elements: <Widget>[
            _VenueOperational(true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (venue.amenities != null)
                  _VenueFeatures(features: venue.amenities),
                SizedBox(width: 16),
                _VenueDistance('5 miles')
              ],
            )
          ],
        ));
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
        fontSize: 14,
        fontWeight: FontWeight.w300,
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
                    Image.asset('images/icons/amenities/$amenity.png',
                        height: 24, width: 24),
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
        fontSize: 14,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: Colors.black,
      ),
    );
  }
}
