import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../design_system.dart';

class DistanceIndicator extends StatelessWidget {
  DistanceIndicator({
    this.userCurrentLocation,
    this.selectedVenueLocation
  });

  final GeoPoint userCurrentLocation;
  final GeoPoint selectedVenueLocation;

  Future<double> distanceFromCurrentLocation() async {
    return await Geolocator().distanceBetween(
        userCurrentLocation.latitude,
        userCurrentLocation.longitude,
        selectedVenueLocation.latitude,
        selectedVenueLocation.longitude
    ) * 0.001;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: distanceFromCurrentLocation(),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              Icon(Icons.location_on, color: Colors.green, size: 20),
              DSComponents.halfSpacer(),
              DSComponents.bodySmall(text: '${snapshot.data.toStringAsFixed(1)} km')
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}