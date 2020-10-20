import 'dart:async';
import 'dart:ui';
import 'package:fisheri/Components/VerticalSlider.dart';
import 'package:fisheri/Components/list_view_button.dart';
import 'package:fisheri/Components/search_bar.dart';
import 'package:fisheri/design_system.dart';
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
import 'package:geolocator/geolocator.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Geoflutterfire _geoFire = Geoflutterfire();
  final Position _defaultPosition = Position(latitude: 51.979900, longitude: -0.214280);
  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;
  final double _selectedVenueCellHeight = 106.0;
  
  GoogleMapController _mapController;
  Firestore _firestore = Firestore.instance;

  StreamSubscription<Position> positionStream;
  Stream<List<DocumentSnapshot>> stream;
  Set<Circle> _circles;

  BitmapDescriptor _pinLocationIcon;
  BehaviorSubject<double> radius = BehaviorSubject();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  
  VenueSearch _selectedVenue;
  List<VenueSearch> _venues = [];
  double _maxSearchRadius = 100;
  Position _currentPosition;
  GeoFirePoint _center;
  bool _autoCompleteVisible = false;
  
  @override
  void initState() {
    super.initState();
    
    radius.value = 15;

    _getCurrentLocation();

    _center = _convertPositionToGeoPoint(_getPosition());
    
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(32, 32)), 'images/icons/map_icon.png').then((onValue) {
      _pinLocationIcon = onValue;
    });

    _setCircles(
        center: _convertPositionToLatLng(_getPosition()),
        radius: radius.value
    );

    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('venues_search');
      if (rad.floor() < _maxSearchRadius) {
        return _geoFire.collection(collectionRef: collectionReference).within(
          center: _center,
          radius: rad,
          field: 'position',
          strictMode: true,
        );
      } else {
        return _geoFire.collection(collectionRef: collectionReference).within(
          center: _center,
          radius: 1000,
          field: 'position',
          strictMode: false,
        );
      }
    });

    positionStream = _geolocator.getPositionStream().listen((position) {
      setState(() {
        _currentPosition = position;
      });
      _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();
    stream = null;
    positionStream = null;
    radius.close();
  }

  bool _isVenueSelected() {
    return _selectedVenue != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Listener(
          onPointerDown: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
            }
            setState(() {
              _autoCompleteVisible = false;
            });
          },
          child: Stack(
              children: <Widget> [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
              target: _convertPositionToLatLng(_getPosition()),
                zoom: 8.0,
              ),
              myLocationEnabled: true,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              circles: _circles,
              onTap: (_) {
                setState(() {
                  _selectedVenue = null;
                });
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SearchBar(
                      onChanged: (value) {
                        setState(() {
                          _autoCompleteVisible = value.isNotEmpty;
                        });
                      }
                    ),
                    ListViewButton(venues: _venues),
                  ],
                )
              )
            ),
            Visibility(
              visible: _autoCompleteVisible,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 69, left: 36),
                  child: Container(
                    height: 200,
                    width: 224,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            offset: Offset(1,6),
                            blurRadius: 12
                        )
                      ]
                    ),
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.location_on, color: DSColors.black),
                          title: DSComponents.body(text:"ben's a bum boy", color: DSColors.grey, alignment: Alignment.topLeft),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on, color: DSColors.black),
                          title: DSComponents.body(text:"Some really really really really really really long text", color: DSColors.grey, alignment: Alignment.topLeft),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ),
            if (_isVenueSelected())
            Align(
              alignment: Alignment.bottomCenter,
              child: _SelectedVenueCell(
                  selectedVenueCellHeight: _selectedVenueCellHeight,
                  selectedVenue: _selectedVenue
              ),
            ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 24,
                        bottom: _isVenueSelected() ? _selectedVenueCellHeight + 48 : 24
                    ),
                    child: VerticalSlider(
                      onChanged: (value) {
                        setState(() {
                          radius.value = value;
                          if (value < _maxSearchRadius) {
                            _setCircles(
                              center: _convertPositionToLatLng(_getPosition()),
                              radius: value
                            );
                          }
                        });
                      },
                    ),
                  ),
                ),
          ]),
        ),
      ),
    );
  }

  void _setCircles({LatLng center, double radius}) {
    setState(() {
      _circles = null;
      _circles = Set.from(
        [
          _makeCircle(
              center: center,
              radius: radius
          ),
        ],
      );
    });
  }

  GeoFirePoint _convertPositionToGeoPoint(Position position) {
    return _geoFire.point(latitude: position.latitude, longitude: position.longitude);
  }

  LatLng _convertPositionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  Position _getPosition() {
    return _currentPosition != null ? _currentPosition : _defaultPosition;
  }

  void _getCurrentLocation() {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _center = _geoFire.point(latitude: _currentPosition.latitude, longitude: _currentPosition.longitude);
      });

      if (_currentPosition != null) {
        CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(target: _convertPositionToLatLng(_currentPosition), zoom: 10.0));
        _mapController.animateCamera(cameraUpdate);

        setState(() {
          _setCircles(
            center: _convertPositionToLatLng(_currentPosition),
            radius: radius.value
          );
        });

        _performSearch();
      }

    }).catchError((e) {
      print(e);
    });
  }

  Circle _makeCircle({LatLng center, double radius}) {
    return Circle(
      circleId: CircleId("123"),
      center: center,
      radius: radius * 1000,
      strokeWidth: 3,
      fillColor: Colors.white.withOpacity(0.4),
      strokeColor: Colors.white,
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
        });
      },
      markerId: markerId,
      position: LatLng(lat, long),
      icon: _pinLocationIcon,
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
}

class _SelectedVenueCell extends StatelessWidget {
  const _SelectedVenueCell({
    Key key,
    @required double selectedVenueCellHeight,
    @required VenueSearch selectedVenue,
  }) : _selectedVenueCellHeight = selectedVenueCellHeight, _selectedVenue = selectedVenue, super(key: key);

  final double _selectedVenueCellHeight;
  final VenueSearch _selectedVenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: MediaQuery.of(context).size.width - 8,
          height: _selectedVenueCellHeight,
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
              height: 275,
              elements: [
                if (_selectedVenue.categories != null)
                VenueCategoriesSection(categories: _selectedVenue.categories, alwaysOpen:  _selectedVenue.alwaysOpen ?? false),
              ],
            ),
          ),
      ),
    );
  }
}
