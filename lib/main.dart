import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Screens/auth_screen.dart';
import 'Screens/detail_screen.dart';
import 'Screens/search_results_screen.dart';
import 'Screens/search_screen.dart';

import 'result_info.dart';
import 'house_colors.dart';
import 'bottom_tab_bar.dart';

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

  TabController _tabController;
  int _selectedTab = 0;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _tabSelected(int newIndex) {
    setState(() {
      _selectedTab = newIndex;
      _tabController.index = newIndex;
    });
  }

  Widget _buildTabContent() {
    return Positioned.fill(
      child: TabBarView(
        controller: _tabController,
        children: [
          AuthScreen(),
          SearchScreen(_controller),
          SearchResultsScreen(MockResultInfo.searchResults),
          DetailScreen(false, HouseColors.primaryGreen)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
        title: Text(
          "Fisheri",
          style: TextStyle(color: HouseColors.white, fontSize: 24.0),
        ),
        backgroundColor: HouseColors.primaryGreen,
        centerTitle: true);

    return new MaterialApp(
      home: Scaffold(
          appBar: _appBar,
          body: Stack(
            children: [
              _buildTabContent(),
              BottomTabs(
                selectedTab: _selectedTab,
                onTap: _tabSelected,
              )
          ])
        ),
      // ), // floatingActionButton: _floatingActionButton)),
    );
  }
  
}
