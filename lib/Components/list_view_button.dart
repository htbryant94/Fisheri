// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../coordinator.dart';
import '../design_system.dart';

class ListViewButton extends StatefulWidget {
  ListViewButton({
    this.venues,
    this.userCurrentLocation,
    this.searchRadius,
    this.searchTown,
  });

  @required
  final List<SearchResult> venues;
  @required
  final Position userCurrentLocation;
  @required
  final double searchRadius;
  @required
  final String searchTown;

  @override
  ListViewButtonState createState() => ListViewButtonState();
}

class ListViewButtonState extends State<ListViewButton> {
  Color _color = DSColors.black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (tapDetails) {
        if (widget.venues != null) {
          Coordinator.searchResultsScreen(
              context: context,
              currentPageTitle: 'Map',
              venues: widget.venues,
              userCurrentLocation: GeoPoint(
                  widget.userCurrentLocation.latitude,
                  widget.userCurrentLocation.longitude,
              ),
            searchRadius: widget.searchRadius,
            searchTown: widget.searchTown,
          );
        }
        setState(() {
          _color = DSColors.black;
        });
      },
      onTapDown: (tapDetails) {
        setState(() {
          _color = DSColors.green;
        });
      },
      onTapCancel: () {
        setState(() {
          _color = DSColors.black;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: _color,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.36),
                  offset: Offset(4,8),
                  blurRadius: 16
              )
            ]
        ),
        padding: EdgeInsets.all(12),
        child: Image.asset(
          'images/icons/list.png',
          color: Colors.white,
        ),
      ),
    );
  }
}

class SearchResult {
  SearchResult({
    this.venue,
    this.geoPoint
  });

  final VenueSearch venue;
  final GeoPoint geoPoint;
}