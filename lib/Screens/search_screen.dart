// @dart=2.9

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fisheri/Components/fisheri_icon_button.dart';
import 'package:fisheri/Components/list_view_button.dart';
import 'package:fisheri/Components/search_bar.dart';
import 'package:fisheri/Screens/search_filter_screen.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  final double _selectedVenueCellHeight = 106.0;
  SearchFilters searchFilters = SearchFilters();
  final iconSize = 125;

  GoogleMapController _mapController;
  String _mapStyle;
  final _firestore = FirebaseFirestore.instance;

  StreamSubscription<Position> positionStream;
  Stream<List<DocumentSnapshot>> stream;
  Set<Circle> _circles = {};

  BitmapDescriptor _mapMarkerLakeUnselectedIcon;
  BitmapDescriptor _mapMarkerLakeSelectedIcon;
  BitmapDescriptor _mapMarkerShopUnselectedIcon;
  BitmapDescriptor _mapMarkerShopSelectedIcon;
  BitmapDescriptor _mapMarkerEmbryoIcon;

  Query _currentCollectionReference;
  final  _defaultCollectionReference = FirebaseFirestore.instance.collection('venues_search');

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
  double _lastCameraZoom;
  LatLng _lastMapPosition;
  double _zoomLevel = 8;
  double _lastRadius;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  @override
  void initState() {
    super.initState();

    radius.value = 15;
    _lastRadius = radius.value;

    _center = _convertPositionToGeoPoint(_getPosition());
    _currentCollectionReference = _defaultCollectionReference;

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    getBitmapDescriptorFromAssetBytes('images/icons/map_marker_lake_unselected.png',iconSize)
        .then((value) {
          setState(() {
            _mapMarkerLakeUnselectedIcon = value;
          });
    });
    getBitmapDescriptorFromAssetBytes('images/icons/map_marker_lake_selected.png',iconSize)
        .then((value) {
      setState(() {
        _mapMarkerLakeSelectedIcon = value;
      });
    });
    getBitmapDescriptorFromAssetBytes('images/icons/map_marker_shop_unselected.png',iconSize)
        .then((value) {
      setState(() {
        _mapMarkerShopUnselectedIcon = value;
      });
    });
    getBitmapDescriptorFromAssetBytes('images/icons/map_marker_shop_selected.png',iconSize)
        .then((value) {
      setState(() {
        _mapMarkerShopSelectedIcon = value;
      });
    });
    getBitmapDescriptorFromAssetBytes('images/icons/map_marker_embryo.png', 100)
        .then((value) {
      setState(() {
        _mapMarkerEmbryoIcon = value;
      });
    });

    stream = radius.switchMap((rad) {
      if (rad.floor() < _maxSearchRadius) {
        return _geoFire.collection(collectionRef: _currentCollectionReference).within(
          center: _center,
          radius: rad,
          field: 'position',
          strictMode: true,
        );
      } else {
        return _geoFire.collection(collectionRef: _currentCollectionReference).within(
          center: _center,
          radius: 1000,
          field: 'position',
          strictMode: false,
        );
      }
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

  void _applyCategoriesFilter(List<String> categories) {
    print('applying categories filter: $categories');
    Query _newCollectionReference;

    if (categories.length == 1) {
      _newCollectionReference = _defaultCollectionReference.where('categories', arrayContains: categories.first);
    } else {
      _newCollectionReference = _defaultCollectionReference.where('categories', isEqualTo: categories);
    }

    setState(() {
      _currentCollectionReference = _newCollectionReference;
      radius.value = _lastRadius;
    });
  }

  void _resetFilters() {
    print('resetting filters');
    setState(() {
      searchFilters = SearchFilters();
      _currentCollectionReference = _defaultCollectionReference;
      radius.value = _lastRadius;
    });
  }

  Future<void> _openGooglePlacesAutocomplete() async {
    final API_KEY = 'AIzaSyC4dxfbMSrSA3x_1ENoo7i9L4EzGJgGAgc';
    final prediction = await PlacesAutocomplete.show(
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
      final _places = GoogleMapsPlaces(apiKey: API_KEY);
      final _detail = await _places.getDetailsByPlaceId(prediction.placeId);
      final latitude = _detail.result.geometry.location.lat;
      final longitude = _detail.result.geometry.location.lng;

      final _newPosition = Position(
          latitude: latitude,
          longitude: longitude
      );

      final cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(target: _convertPositionToLatLng(_newPosition), zoom: _getZoomLevel(_circles.first)));
      await _mapController.animateCamera(cameraUpdate);

      setState(() {
        _currentPosition = _newPosition;
        _currentSearchText = _detail.result.name;
        _center = GeoFirePoint(_newPosition.latitude, _newPosition.longitude);
        radius.value = _lastRadius;
        _setCircles(
            center: _convertPositionToLatLng(_newPosition),
            radius: radius.value
        );
      });

      _performSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Listener(
          onPointerDown: (_) {
            final currentFocus = FocusScope.of(context);
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
                  _lastCameraZoom = cameraPosition.zoom;
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
                      title: 'Search this area',
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onTap: () async {
                        final _newPosition = Position(latitude: _lastMapPosition.latitude, longitude: _lastMapPosition.longitude);
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
                    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                        .then((position) {
                          final cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(target: _convertPositionToLatLng(position), zoom: _lastCameraZoom));
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
                      onTap: _openGooglePlacesAutocomplete,
                      onFiltersPressed: () {
                        Coordinator.present(
                          context,
                          screen: SearchFilterScreen(
                            searchFilters: searchFilters,
                            onResetPressed: _resetFilters,
                            onChanged: (newSearchFilters) {
                              searchFilters = newSearchFilters;
                              List<String> _categories = [];

                              print('onChanged');

                              if (searchFilters.lake != null) {
                                if (searchFilters.lake) {
                                  _categories.add('lake');
                                }
                              }

                              if (searchFilters.shop != null) {
                                if (searchFilters.shop) {
                                  _categories.add('shop');
                                }
                              }

                              if (_categories.isNotEmpty) {
                                _applyCategoriesFilter(_categories);
                              } else {
                                print('no filters applied, resetting');
                                _resetFilters();
                              }
                            },
                            searchRadiusChanged: (miles) {
                              print('search radius changed');
                              searchFilters.searchRadius = miles;
                              final kilometres = (miles * 1.609344).toDouble();
                              setState(() {
                                radius.value = kilometres;
                                _lastRadius = kilometres;
                                if (kilometres < _maxSearchRadius) {
                                  _setCircles(
                                      center: _convertPositionToLatLng(_getPosition()),
                                      radius: kilometres
                                  );
                                }
                              });
                            },
                          ),
                          screenTitle: 'Filters',
                        );
                      },
                    ),
                    ListViewButton(
                      venues: _venues,
                      userCurrentLocation: _getPosition(),
                      searchRadius: _lastRadius,
                      searchTown: _currentSearchText,
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
                  currentPosition: GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
              ),
            ),
                // Align(
                //   alignment: Alignment.bottomLeft,
                //   child: Padding(
                //     padding: EdgeInsets.only(
                //         left: 24,
                //         bottom: _isVenueSelected() ? _selectedVenueCellHeight + 48 : 24
                //     ),
                //     child: VerticalSlider(
                //       onChanged: (value) {
                //         setState(() {
                //           radius.value = value;
                //           _lastRadius = value;
                //           if (value < _maxSearchRadius) {
                //             _setCircles(
                //               center: _convertPositionToLatLng(_getPosition()),
                //               radius: value
                //             );
                //           }
                //         });
                //       },
                //     ),
                //   ),
                // ),
          ]),
        ),
      ),
    );
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
      _circles = {
          _makeCircle(
              center: center,
              radius: radius
          ),
        };
    });
  }

  GeoFirePoint _convertPositionToGeoPoint(Position position) {
    return _geoFire.point(latitude: position.latitude, longitude: position.longitude);
  }

  LatLng _convertPositionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  Position _getPosition() {
    return _currentPosition ?? _defaultPosition;
  }

  void _getCurrentLocation() {
    Geolocator
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

        final _latLng = LatLng(position.latitude, position.longitude);
        final _cameraPosition = CameraPosition(target: _latLng, zoom: _getZoomLevel(_circles.first));
        _moveCamera(_cameraPosition);
        _performSearch();
      }

    }).catchError((e) {
      print(e);
    });
  }

  void _moveCamera(CameraPosition cameraPosition) {
     final _cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    _mapController.animateCamera(_cameraUpdate);
  }

  void _searchThisArea(Position position) {
    setState(() {
      _currentPosition = position;
      _currentSearchText = null;
      _center = GeoFirePoint(position.latitude, position.longitude);
      radius.value = _lastRadius ?? radius.value;
      _setCircles(
          center: _convertPositionToLatLng(position),
          radius: radius.value
      );
    });

    final cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(target: _convertPositionToLatLng(position), zoom: _lastCameraZoom));
    _mapController.animateCamera(cameraUpdate);
    _performSearch();
  }

  Circle _makeCircle({LatLng center, double radius}) {
    return Circle(
      circleId: CircleId('123'),
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

    documentList.forEach((DocumentSnapshot document) {
      // final result = VenueSearchJSONSerializer().fromMap(document.data());
      final result = VenueSearch(); // TEMP
      if (result != null) {
        final json = document.data() as Map<String, dynamic>;
        GeoPoint point = json['position']['geopoint'];
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

  BitmapDescriptor _getMapMarkerIcon(VenueSearch venue) {
    if (venue.name.contains('Embryo Angling')) {
      return _mapMarkerEmbryoIcon;
    } else if (_selectedVenue != null) {
      if (venue.id == _selectedVenue.id && venue.categories.contains('lake')) {
        return _mapMarkerLakeSelectedIcon;
      } else if (venue.id != _selectedVenue.id && venue.categories.contains('lake')) {
        return _mapMarkerLakeUnselectedIcon;
      } else if (venue.id == _selectedVenue.id && !venue.categories.contains('lake')) {
        return _mapMarkerShopSelectedIcon;
      } else if (venue.id != _selectedVenue.id && !venue.categories.contains('lake')) {
        return _mapMarkerShopUnselectedIcon;
      }
    } else {
      if (venue.categories.contains('lake')) {
        return _mapMarkerLakeUnselectedIcon;
      } else {
        return _mapMarkerShopUnselectedIcon;
      }
    }
  }

  void _addMarker(
      {VenueSearch venue, double lat, double long, String venueType}) async {
    final markerId = MarkerId(venue.id);
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
      icon: _getMapMarkerIcon(venue),
    );
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void _performSearch() {
    print('performSearch()');
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
    });
    _mapController.setMapStyle(_mapStyle);
    _getCurrentLocation();
  }
}

class _SelectedVenueCell extends StatelessWidget {
  const _SelectedVenueCell({
    Key key,
    @required double selectedVenueCellHeight,
    @required VenueSearch selectedVenue,
    @required GeoPoint currentPosition,
  }) :
        _selectedVenueCellHeight = selectedVenueCellHeight,
        _selectedVenue = selectedVenue,
        _currentPosition = currentPosition,
        super(key: key);

  final double _selectedVenueCellHeight;
  final VenueSearch _selectedVenue;
  final GeoPoint _currentPosition;

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
                  Coordinator.pushVenueDetailScreen(
                    context,
                    'Map',
                    venue, _selectedVenue.imageURL,
                    _selectedVenue.id,
                    _currentPosition
                  );
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
