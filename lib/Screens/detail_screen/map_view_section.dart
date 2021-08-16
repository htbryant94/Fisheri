// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../design_system.dart';

class MapViewSection extends StatefulWidget {
  MapViewSection({
    @required this.address,
    this.coordinates,
  });

  final VenueAddress address;
  final GeoPoint coordinates;

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse('comgooglemaps://?q=$lat, $lng');
    if (await canLaunch(uri.toString())) {
      print(uri.toString());
      await launch(uri.toString());
    } else {
      print('could not launch URL: ${uri.toString()}');
      throw 'Could not launch ${uri.toString()}';
    }
  }

  @override
  _MapViewSectionState createState() => _MapViewSectionState();
}

class _MapViewSectionState extends State<MapViewSection> {
  BitmapDescriptor _pinLocationIconGreen;

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'images/icons/map_marker_selected.png'
    ).then((onValue) {
      setState(() {
        _pinLocationIconGreen = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _latLng = LatLng(widget.coordinates.latitude, widget.coordinates.longitude);

    return Column(
      children: [
        DSComponents.header(text: 'Location'),
        DSComponents.paragraphSpacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 200,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: _latLng, zoom: 9),
            markers: Set<Marker>.of({
              Marker(
                markerId: MarkerId('1'),
                position: _latLng,
                icon: _pinLocationIconGreen,
              )
            }),
            scrollGesturesEnabled: false,
            myLocationButtonEnabled: false,
          ),
        ),
        Visibility(
          visible: widget.coordinates != null,
          child: Column(
            children: [
              DSComponents.paragraphSpacer(),
              DSComponents.secondaryButton(
                  text: 'Get Directions',
                  onPressed: () {
                    MapViewSection.navigateTo(widget.coordinates.latitude, widget.coordinates.longitude);
                  }),
            ],
          ),
        ),
        DSComponents.paragraphSpacer(),
        DSComponents.body(
            text: '${widget.address.street}', alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(text: '${widget.address.town}', alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(
            text: '${widget.address.county}', alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(
            text: '${widget.address.postcode}', alignment: Alignment.center),
      ],
    );
  }
}