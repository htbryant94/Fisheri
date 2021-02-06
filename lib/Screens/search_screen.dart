import 'dart:async';
import 'dart:ui';
import 'package:fisheri/Components/VerticalSlider.dart';
import 'package:fisheri/Components/fisheri_icon_button.dart';
import 'package:fisheri/Components/list_view_button.dart';
import 'package:fisheri/Components/search_bar.dart';
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
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:math';

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
  final _firestore = FirebaseFirestore.instance;

  StreamSubscription<Position> positionStream;
  Stream<List<DocumentSnapshot>> stream;
  Set<Circle> _circles;

  BitmapDescriptor _pinLocationIcon;
  BitmapDescriptor _pinLocationIconGreen;

  BehaviorSubject<double> radius = BehaviorSubject();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;

  VenueSearch _selectedVenue;
  List<SearchResult> _venues = [];
  double _maxSearchRadius = 100;
  Position _currentPosition;
  GeoFirePoint _center;

  List<DocumentSnapshot> _venueResults;

  String _currentSearchText;
  bool _showSearchThisArea = false;
  LatLng _lastMapPosition;
  double _zoomLevel = 8;

  @override
  void initState() {
    super.initState();

    radius.value = 15;

    _center = _convertPositionToGeoPoint(_getPosition());

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'images/icons/map_marker_unselected.png'
    ).then((onValue) {
      _pinLocationIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'images/icons/map_marker_selected.png'
    ).then((onValue) {
      _pinLocationIconGreen = onValue;
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
          },
          child: Stack(
              children: <Widget> [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
              target: _convertPositionToLatLng(_getPosition()),
                zoom: _zoomLevel,
              ),
              myLocationEnabled: true,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              onCameraMove: (cameraPosition) {
                setState(() {
                  _lastMapPosition = cameraPosition.target;
                  _showSearchThisArea = true;
                });
              },
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              circles: _circles,
              onTap: (_) {
                setState(() {
                  _selectedVenue = null;
                  _updateMarkers(_venueResults);
                });
              },
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Visibility(
                    visible: _showSearchThisArea,
                    child: FisheriIconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onTap: () async {
                        final Position _newPosition = Position(latitude: _lastMapPosition.latitude, longitude: _lastMapPosition.longitude);
                        _searchThisArea(_newPosition);
                      },
                    ),
                  ),
                )
            ),
            Positioned(
                bottom: 24,
                right: 24,
                child: FisheriIconButton(
                  icon: Icon(Icons.my_location, color: Colors.white),
                  onTap: () async {
                    await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                        .then((position) {
                          CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(target: _convertPositionToLatLng(position), zoom: _getZoomLevel(_circles.first)));
                          _mapController.animateCamera(cameraUpdate);
                        }
                    );
                  },
                )
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SearchBar(
                      text: _currentSearchText,
                      onTap: _openGooglePlacesAutocomplete
                    ),
                    ListViewButton(
                      venues: _venues,
                      userCurrentLocation: _getPosition(),
                    ),
                  ],
                )
              )
            ),
            if (_isVenueSelected())
            Align(
              alignment: Alignment.bottomCenter,
              child: _SelectedVenueCell(
                  selectedVenueCellHeight: _selectedVenueCellHeight,
                  selectedVenue: _selectedVenue,
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

  Future<void> _openGooglePlacesAutocomplete() async {
    final API_KEY = "AIzaSyC4dxfbMSrSA3x_1ENoo7i9L4EzGJgGAgc";
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: API_KEY,
        mode: Mode.overlay,
        language: 'en',
        components: [Component(Component.country, 'uk')],
        onError: (response) {
          print('Error with Places API: ${response.errorMessage}');
        }
    );

    if (prediction != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: API_KEY);
      PlacesDetailsResponse _detail = await _places.getDetailsByPlaceId(prediction.placeId);
      double latitude = _detail.result.geometry.location.lat;
      double longitude = _detail.result.geometry.location.lng;

      Position _newPosition = Position(
          latitude: latitude,
          longitude: longitude
      );

      CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(target: _convertPositionToLatLng(_newPosition), zoom: _getZoomLevel(_circles.first)));
      await _mapController.animateCamera(cameraUpdate);

      setState(() {
        _currentPosition = _newPosition;
        _currentSearchText = _detail.result.name;
        _center = GeoFirePoint(_newPosition.latitude, _newPosition.longitude);
        _setCircles(
            center: _convertPositionToLatLng(_newPosition),
            radius: radius.value
        );
      });

      _performSearch();
    }
  }

  double _getZoomLevel(Circle circle) {
    double zoomLevel = 11;
    if (circle != null) {
      double scale = circle.radius / 500;
      zoomLevel = (16 - log(scale) / log(2));
    }
    return zoomLevel;
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

  void _moveCamera(CameraPosition cameraPosition) {
     CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    _mapController.animateCamera(cameraUpdate);
  }

  void _searchThisArea(Position position) {
    setState(() {
      _currentPosition = position;
      _currentSearchText = null;
      _center = GeoFirePoint(position.latitude, position.longitude);
      _setCircles(
          center: _convertPositionToLatLng(position),
          radius: radius.value
      );
    });
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(target: _convertPositionToLatLng(position), zoom: _getZoomLevel(_circles.first)));
    _mapController.animateCamera(cameraUpdate);
    _performSearch();
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

//    print(documentList.length);
    documentList.forEach((DocumentSnapshot document) {
      final result =
          VenueSearchJSONSerializer().fromMap(document.data());
      if (result != null) {
        GeoPoint point = document.data()['position']['geopoint'];
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
          _venues.add(
              SearchResult(
                  venue: result,
                  geoPoint: point
              )
          );
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
    final MarkerId markerId = MarkerId(venue.id);
    var _marker = Marker(
      onTap: () async {
        setState(() {
          _selectedVenue = venue;
        });
        _updateMarkers(_venueResults);
      },
      markerId: markerId,
      position: LatLng(lat, long),
      zIndex: _selectedVenue != null ? (venue.id == _selectedVenue.id ? 1.0 : 0.0) : 0.0,
      icon: _selectedVenue != null ? (venue.id == _selectedVenue.id ? _pinLocationIconGreen : _pinLocationIcon) : _pinLocationIcon,
    );
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void _performSearch() {
    print('current search radius: ${radius.value}');
    setState(() {
      _zoomLevel = _getZoomLevel(_circles.first);
      _showSearchThisArea = false;
      stream.listen((List<DocumentSnapshot> documentList) {
        _venueResults = documentList;
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
  }) :
        _selectedVenueCellHeight = selectedVenueCellHeight,
        _selectedVenue = selectedVenue,
        super(key: key);

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
                  Coordinator.pushVenueDetailScreen(context, 'Map', venue, _selectedVenue.imageURL, _selectedVenue.id);
                }
              });
            },
            child: RemoteImageBaseCell(
              imageURL: _selectedVenue.imageURL,
              title: _selectedVenue.name,
              subtitle: _selectedVenue.address.town,
              height: 275,
              elements: [
                VenueCategoriesSection(categories: _selectedVenue.categories, alwaysOpen:  _selectedVenue.alwaysOpen ?? false),
              ],
            ),
          ),
      ),
    );
  }
}
