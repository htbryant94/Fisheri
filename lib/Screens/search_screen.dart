import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen(this.mapController);

  // Geoflutterfire _geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;

  final Completer<GoogleMapController> mapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    // GeoFirePoint myLocation = _geo.point(latitude: 52.1067, longitude: -0.2756);
    // _firestore
    //     .collection("venues_locations")
    //     .add({'name': 'something', 'position': myLocation.data});
    // GeoFirePoint center = _geo.point(latitude: 52.1067, longitude: -0.2756);
    var collectionReference = _firestore.collection('locations');

    // double radius = 50;
    // String field = 'position';

    // Stream<List<DocumentSnapshot>> stream = _geo
    //     .collection(collectionRef: collectionReference)
    //     .within(center: center, radius: radius, field: field);

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
    );
  }
}
