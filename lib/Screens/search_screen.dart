import 'dart:async';
import 'package:fisheri/models/venue_search.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fisheri/Components/base_cell.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/firestore_request_service.dart';

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

  BitmapDescriptor pinLocationIcon;
  BehaviorSubject<double> radius = BehaviorSubject();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  double _radiusSliderValue = 0;
  final _latitude = 51.979900;
  final _longitude = -0.214280;
  VenueSearch _selectedVenue;
  String _selectedVenueType;
  List<VenueSearch> _venues = [];
  double _maxSearchRadius = 100;

  @override
  void initState() {
    super.initState();
    geo = Geoflutterfire();
    radius.value = 15;
    _radiusSliderValue = radius.value;
    GeoFirePoint center = geo.point(latitude: _latitude, longitude: _longitude);
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(32, 32)), 'images/icons/map_icon.png').then((onValue) {
      pinLocationIcon = onValue;
    });

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
      var collectionReference = _firestore.collection('venues_search');
      if (rad.floor() < _maxSearchRadius) {
        return geo.collection(collectionRef: collectionReference).within(
            center: center,
            radius: rad,
            field: 'position',
            strictMode: true
        );
      } else {
        return geo.collection(collectionRef: collectionReference).within(
          center: center,
          radius: 1000,
          field: 'position',
          strictMode: false,
        );
      }
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
      return _selectedVenue != null;
    }

    String getSearchRadius(int radius) {
      return radius == _maxSearchRadius ? '∞' : "$radius";
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget> [
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
              child: _ListViewButton(venues: _venues),
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
                        onTap: () async {
                          await FirestoreRequestService.defaultService().getVenueDetailed(_selectedVenue.id).then((venue) {
                            if (venue != null) {
                              Coordinator.pushVenueDetailScreen(context, 'Map', venue, _selectedVenue.imageURL);
                            }
                          });
                        },
                        child: RemoteImageBaseCell(
                          imageURL: _selectedVenue.imageURL,
                          title: _selectedVenue.name,
                          subtitle: _selectedVenue.address.town,
                          elements: [
                            if (_selectedVenue.categories != null)
                            VenueCategoriesSection(categories: _selectedVenue.categories),
                          ],
                        ),
                      ),
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
                        RotatedBox(
                            child: Text(getSearchRadius(radius.value.round())),
                            quarterTurns: 1),
                        Slider(
                          value: _radiusSliderValue,
                          max: _maxSearchRadius,
                          onChanged: (value) {
                            setState(() {
                              radius.value = value;
                              circles = null;
                              if (value < _maxSearchRadius) {
                                circles = Set.from([
                                  Circle(
                                    circleId: CircleId("123"),
                                    center: LatLng(_latitude, _longitude),
                                    radius: (value * 1000),
                                    strokeWidth: 2,
                                    fillColor:
                                    Colors.greenAccent.withOpacity(0.6),
                                    strokeColor: Colors.green[200],
                                  )
                                ]);
                              }
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
      _venues = [];
    });

    print(documentList.length);
    documentList.forEach((DocumentSnapshot document) {
      final VenueSearch result =
          VenueSearchJSONSerializer().fromMap(document.data);
      if (result != null) {
        GeoPoint point = document.data['position']['geopoint'];
        List<String> venueTypes = result.categories.cast<String>();

        String venueType;
        venueTypes.where((venue) => venue != null).forEach((venue) {
          if (venueType == null || venueType.isEmpty) {
            venueType = venue;
          } else {
            venueType += ', $venue';
          }
        });

        setState(() {
          _venues.add(result);
        });

        _addMarker(
          venue: result,
          lat: point.latitude,
          long: point.longitude,
          venueType: venueType,
        );
      }
    });
  }

  void _addMarker(
      {VenueSearch venue, double lat, double long, String venueType}) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    var _marker = Marker(
      onTap: () async {
        setState(() {
          _selectedVenue = venue;
          _selectedVenueType = venueType;
        });
      },
      markerId: markerId,
      position: LatLng(lat, long),
      icon: pinLocationIcon,
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
        .collection('venues_search')
        .add({'name': 'test name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }
}

class _ListViewButton extends StatelessWidget {
  _ListViewButton({this.venues});

  @required
  final List<VenueSearch> venues;

  @override
  Widget build(BuildContext context) {
        return CupertinoButton(
          disabledColor: Colors.grey,
          color: Colors.blue,
          child: Icon(Icons.apps, color: Colors.white),
          onPressed: venues != null ? () {
            Coordinator.pushSearchResultsScreen(context, 'Map', venues);
          } : null,
      );
  }
}
