import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

    bool _descriptionExpanded = false;
    Widget textSection = Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: <Widget>[
            Text(
              'Description',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            Text(
              'Manor Farm Lakes is an extensive 100 acre fishery based in the heart of Central Bedfordshire, with easy access from the A1. Manor Farm Lakes consists of a range of 7 different fishing lakes with an 18 van touring caravan site with electric hook-ups. A range of fishing experiences are catered for at Manor Farm Lakes including carp fishing for pleasure anglers and specialists, night fishing, fly fishing for carp, match and coarse angling as well as predator spinning, lure and deadbait fishing in the winter months. The River Ivel acts as the boundary along our eastern edge and is also available to fish with a good head of chub, barbel, pike and bream.',
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: _descriptionExpanded ? 8 : 4,
            ),
            FlatButton(
              onPressed: () {
                print(_descriptionExpanded);
                _descriptionExpanded = !_descriptionExpanded;
              },
              child: Text("Read More", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ));

    Widget amenetiesSection = Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: <Widget>[
            Text(
              'Ameneties',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            Text(
              'Manor Farm Lakes is an extensive 100 acre fishery based in the heart of Central Bedfordshire, with easy access from the A1. Manor Farm Lakes consists of a range of 7 different fishing lakes with an 18 van touring caravan site with electric hook-ups. A range of fishing experiences are catered for at Manor Farm Lakes including carp fishing for pleasure anglers and specialists, night fishing, fly fishing for carp, match and coarse angling as well as predator spinning, lure and deadbait fishing in the winter months. The River Ivel acts as the boundary along our eastern edge and is also available to fish with a good head of chub, barbel, pike and bream.',
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: _descriptionExpanded ? 8 : 4,
            ),
            FlatButton(
              onPressed: () {
                print(_descriptionExpanded);
                _descriptionExpanded = !_descriptionExpanded;
              },
              child: Text("Read More", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ));

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButtonColumn(color, Icons.call, 'Call'),
          _buildButtonColumn(color, Icons.language, 'Website'),
          _buildButtonColumn(color, Icons.email, 'Email'),
        ],
      ),
    );

    Widget overviewBox = SizedBox(
      width: 50,
      height: 50,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.green),
      ),
    );

    Widget overviewRow = Row(
      children: <Widget>[overviewBox, overviewBox, overviewBox, overviewBox],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget overviewGrid = Column(
      children: <Widget>[
        overviewRow,
        const Padding(padding: EdgeInsets.only(bottom: 32.0)),
        overviewRow
      ],
    );

    Widget overviewSection = Container(
      padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
      child: Column(
        children: <Widget>[
          Text(
            'Overview',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 16.0)),
          overviewGrid
        ],
      ),
    );

    Widget titleSection = Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Manor Farm Lakes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                Text('Biggleswade, Hertfordshire',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                    ))
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
        ],
      ),
    );

    Widget _detailScreen = ListView(
      children: [
        Image.asset(
          'images/lake.jpg',
          width: 600,
          height: 240,
          fit: BoxFit.cover,
        ),
        titleSection,
        textSection,
        buttonSection,
        const Padding(padding: EdgeInsets.only(bottom: 16)),
        overviewSection,
        amenetiesSection
      ],
    );

    final List<Widget> _children = [
      _loginScreen,
      _searchScreen,
      _resultsScreen,
      _detailScreen
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
