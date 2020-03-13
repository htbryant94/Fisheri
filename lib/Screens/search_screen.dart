import 'dart:async';
import 'package:fisheri/search_result_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/Components/base_cell.dart';
import 'package:fisheri/coordinator.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GoogleMapController _mapController;
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  Set<Circle> circles;

  BehaviorSubject<double> radius = BehaviorSubject();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  double _radiusSliderValue = 0;
  final _latitude = 51.979900;
  final _longitude = -0.214280;
  String _selectedVenueName;
  String _selectedVenueType;
  String _selectedVenueID;

  @override
  void initState() {
    super.initState();
    geo = Geoflutterfire();
    radius.value = 15;
    _radiusSliderValue = radius.value;
    GeoFirePoint center = geo.point(latitude: _latitude, longitude: _longitude);

    circles = Set.from([
      Circle(
        circleId: CircleId("123"),
        center: LatLng(_latitude, _longitude),
        radius: (radius.value * 1000),
        strokeWidth: 2,
        fillColor: Colors.greenAccent.withOpacity(0.6),
        strokeColor: Colors.green[200],
      )
    ]);

    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('venues_locations');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    });
//    _addPoint(51.979900, -0.214280);
  }

  @override
  void dispose() {
    super.dispose();
    radius.close();
  }

  @override
  Widget build(BuildContext context) {

    bool shouldShowVenueCard() {
      return _selectedVenueID != null &&
             _selectedVenueType != null &&
             _selectedVenueName != null;
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(51.979900, -0.214280),
              zoom: 8.0,
            ),
            compassEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            circles: circles,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topRight,
              child: _ListViewButton(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (shouldShowVenueCard())
                Container(
                  width: MediaQuery.of(context).size.width - 8,
                  height: 100,
                  child: GestureDetector(
                    onTap: () {
                      _firestore.collection('venues_detail').document(_selectedVenueID).get().then((DocumentSnapshot document) {
                        final _venue = document;
                        final _venueDetailed = VenueDetailed(
                          name: _venue['name'],
                          isLake: _venue['isLake'],
                          isShop: _venue['isShop'],
                          description: _venue['description'],
                          social: SocialJSONSerializer().fromMap(_venue['social']),
                          address: VenueAddressJSONSerializer().fromMap(_venue['address']),
                          fishingTypes: _venue['fishing_types_array'],
                          fishStocked: _venue['fish_stock_array'],
                          amenities: _venue['amenities_array'],
                          tickets: _venue['tickets_array'],
                          fishingRules: _venue['fishing_rules'],
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondRoute(
                              title: _venueDetailed.name,
                              descriptionText: _venueDetailed.description,
                              fishStock: _venueDetailed.fishStocked,
                              fishTypes: _venueDetailed.fishingTypes,
                              amenities: _venueDetailed.amenities,
                              openingHours: _venueDetailed.operationalHours,
                              address: _venueDetailed.address,
                              tickets: _venueDetailed.tickets,
                              fishingRules: _venueDetailed.fishingRules,
                              index: 0,
                            ),
                          ),
                        );
                      });
                    },
                    child: BaseCell(
                      title: _selectedVenueName,
                      subtitle: _selectedVenueType,
                      image: Image.asset('images/lake.jpg'),
                    ),
                  )
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RotatedBox(
              quarterTurns: 3,
              child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  height: 50,
                  width: 250,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RotatedBox(child: Text('km'), quarterTurns: 1),
                        RotatedBox(child: Text('${radius.value.round()}'), quarterTurns: 1),
                        Slider(
                          value: _radiusSliderValue,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              radius.value = value;
                              circles = null;
                              circles = Set.from([
                                Circle(
                                  circleId: CircleId("123"),
                                  center: LatLng(_latitude, _longitude),
                                  radius: (value * 1000),
                                  strokeWidth: 2,
                                  fillColor: Colors.greenAccent.withOpacity(0.6),
                                  strokeColor: Colors.green[200],
                                )
                              ]);
                              _radiusSliderValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ]),
      ),
    );
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    setState(() {
      markers = {};
    });
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['position']['geopoint'];
      String name = document.data['name'];
      String id = document.data['id'];
      bool isLake = document.data['isLake'];
      bool isShop = document.data['isShop'];
      List<String> venueTypes = [];
      venueTypes.add(isLake == true ? 'Lake' : null);
      venueTypes.add(isShop == true ? 'Shop' : null);

      String venueType;
      venueTypes.where((venue) => venue != null).forEach((venue) {
        if (venueType == null || venueType.isEmpty) {
          venueType = venue;
        } else {
          venueType += ', $venue';
        }
      });

      _addMarker(
          name: name,
          id: id,
          lat: point.latitude,
          long: point.longitude,
          venueType: venueType);
    });
  }

  void _addMarker({String name, String id, double lat, double long, String venueType}) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    var _marker = Marker(
      onTap: () {
        setState(() {
          _selectedVenueName = name;
          _selectedVenueType = venueType;
          _selectedVenueID = id;
        });
      },
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void _performSearch() {
    print('current search radius: ${radius.value}');

    setState(() {
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      }).onError((error) {
        print('error streaming: $error');
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _performSearch();
    });
  }

  void _addPoint(double lat, double long) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: long);
    _firestore
        .collection('venues_locations')
        .add({'name': 'test name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }
}

class _ListViewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue
      ),
      child: CupertinoButton(
        child: Icon(Icons.apps, color: Colors.white),
        onPressed: () {
          Coordinator.pushSearchResultsScreen(context, 'Map');
        },
      ),
    );
  }
}

