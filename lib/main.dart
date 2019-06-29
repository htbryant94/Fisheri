import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_flutter_project/detail_screen.dart';

import 'result_info.dart';
import 'search_result_cell.dart';

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
  final items = List<String>.generate(100, (i) => "Item $i");
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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    Column _buildButtonColumn(Color color, IconData icon, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    Color color = Theme.of(context).primaryColor;

    Widget _searchScreen = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );

    Widget _resultsScreen = Align(
        alignment: Alignment.center,
        child: ListView.separated(
          itemCount: _searchResults.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                color: Colors.grey[700],
              ),
          itemBuilder: (context, index) {
            final _lakeToString =
                _searchResults[index].isLake ? "LAKE" : "SHOP";
            return SearchResultCell(
              imageURL: 'images/lake.jpg',
              title: '${_searchResults[index].title}',
              venueType: _lakeToString,
              distance: '${_searchResults[index].distance}',
              isOpen: _searchResults[index].isOpen,
            );
          },
        ));

    Widget _loginScreen = Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Image.asset(
                'images/lake.jpg',
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Log In with Google',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Log In with Facebook',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Log In with Email',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Sign Up', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ));

    final List<Widget> _children = [
      _loginScreen,
      _searchScreen,
      _resultsScreen,
      DetailScreen(false, color)
    ];

    return new MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Fisheri",
                style: TextStyle(color: Color(0xffE4E4E4), fontSize: 24.0),
              ),
              backgroundColor: Color(0xff115429),
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
              backgroundColor: Color(0xff115429),
              items: [
                BottomNavigationBarItem(
                    activeIcon: Icon(Icons.explore),
                    backgroundColor: Color(0xff115429),
                    icon: Icon(Icons.explore, color: Color(0xffE4E4E4)),
                    title: Text(
                      'Login',
                      style: TextStyle(color: Color(0xffE4E4E4)),
                    )),
                BottomNavigationBarItem(
                    activeIcon: Icon(Icons.search),
                    backgroundColor: Color(0xff115429),
                    icon: Icon(Icons.search, color: Color(0xffE4E4E4)),
                    title: Text(
                      'Search',
                      style: TextStyle(color: Color(0xffE4E4E4)),
                    )),
                BottomNavigationBarItem(
                    backgroundColor: Color(0xff115429),
                    icon: Icon(Icons.star, color: Color(0xffE4E4E4)),
                    title: Text(
                      'Results',
                      style: TextStyle(color: Color(0xffE4E4E4)),
                    )),
                BottomNavigationBarItem(
                    backgroundColor: Color(0xff115429),
                    icon: Icon(Icons.account_circle, color: Color(0xffE4E4E4)),
                    title: Text(
                      'Venue',
                      style: TextStyle(color: Color(0xffE4E4E4)),
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
            //     style: TextStyle(color: Color(0xff115429)),
            //   ),
            //   icon: Icon(
            //     Icons.directions_boat,
            //     color: Color(0xff115429),
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