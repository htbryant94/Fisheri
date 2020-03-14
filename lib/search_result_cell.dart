import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/material.dart';
import 'Components/base_cell.dart';
import 'coordinator.dart';
import 'models/venue_detailed.dart';

import 'package:google_fonts/google_fonts.dart';

class SearchResultCell extends StatelessWidget {
  SearchResultCell({
    @required
    this.venue,
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
            Coordinator.pushVenueDetailScreen(context, 'Map', _venue);
          });
        },
      child: BaseCell(
        title: venue.name,
        subtitle: 'TODO',
        image: Image.asset('images/lake.jpg'),
        elements: <Widget>[
          _VenueOperational(true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _VenueFeatures(),
              _VenueDistance('5 miles'),
            ],
          )
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
        fontSize: 14,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        color:isOpen ? Colors.green : Colors.red,
      ),
    );
  }
}

class _VenueFeatures extends StatelessWidget {
  // _VenueFeatures(this.features);

  // final List<Icon> features;

  @override
  Widget build(BuildContext context) {
    const double _spacing = 4;
    return Row(
      children: [
        Icon(Icons.directions_boat),
        SizedBox(width: _spacing),
        Icon(Icons.directions_bike),
        SizedBox(width: _spacing),
        Icon(Icons.add_location),
        SizedBox(width: _spacing),
        Icon(Icons.description),
      ],
    );
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
