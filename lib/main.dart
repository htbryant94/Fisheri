import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Screens/auth_screen.dart';
import 'Screens/detail_screen.dart';
import 'Screens/search_results_screen.dart';
import 'Screens/search_screen.dart';

import 'result_info.dart';
import 'house_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  Completer<GoogleMapController> _controller = Completer();

  final List<ResultInfo> _searchResults = [
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
  ];

  void _incrementTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    final List<Widget> _children = [
      AuthScreen(),
      SearchScreen(_controller),
      SearchResultsScreen(_searchResults),
      DetailScreen(false, color)
    ];

    return new MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Fisheri",
                style: TextStyle(color: HouseColors.white, fontSize: 24.0),
              ),
              // backgroundColor: HouseColors.primaryGreen,
              backgroundColor: HouseColors.primaryGreen,
              centerTitle: true,
              // bottom: PreferredSize(
              //   preferredSize: const Size.fromHeight(48),
              //   child: Theme(
              //     data: Theme.of(context).copyWith(accentColor: Colors.white),
              //     child: Container(
              //         height: 48.0,
              //         alignment: Alignment.center,
              //         child: Align(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             height: 20,
              //             width: 250,
              //             child: TextField(
              //             decoration: InputDecoration(
              //                 border: InputBorder.none,
              //                 hintText: 'Enter a search term'),
              //           ),
              //         )
              //           )
              //         // child: TabPageSelector(controller: _tabController),
              //         ),
              //   ),
              // ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.shifting,
              backgroundColor: HouseColors.primaryGreen,
              items: [
                BottomNavigationBarItem(
                    activeIcon: Icon(Icons.explore),
                    backgroundColor: HouseColors.primaryGreen,
                    icon: Icon(Icons.explore, color: HouseColors.white),
                    title: Text(
                      'Login',
                      style: TextStyle(color: HouseColors.white),
                    )),
                BottomNavigationBarItem(
                    activeIcon: Icon(Icons.search),
                    backgroundColor: HouseColors.primaryGreen,
                    icon: Icon(Icons.search, color: HouseColors.white),
                    title: Text(
                      'Search',
                      style: TextStyle(color: HouseColors.white),
                    )),
                BottomNavigationBarItem(
                    backgroundColor: HouseColors.primaryGreen,
                    icon: Icon(Icons.star, color: HouseColors.white),
                    title: Text(
                      'Results',
                      style: TextStyle(color: HouseColors.white),
                    )),
                BottomNavigationBarItem(
                    backgroundColor: HouseColors.primaryGreen,
                    icon: Icon(Icons.account_circle, color: HouseColors.white),
                    title: Text(
                      'Venue',
                      style: TextStyle(color: HouseColors.white),
                    ))
              ],
              onTap: (index) {
                _incrementTab(index);
              },
            ),
            body: Center(
              child: _children[_selectedIndex],
            ),
            // floatingActionButton: FloatingActionButton.extended(
            //   onPressed: _goToTheLake,
            //   label: Text(
            //     'To the lake!',
            //     style: TextStyle(color: HouseColors.primaryGreen),
            //   ),
            //   icon: Icon(
            //     Icons.directions_boat,
            //     color: HouseColors.primaryGreen,
            //   ),
            //   backgroundColor: Color(0xffC7D648),
            // ),
          )),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
