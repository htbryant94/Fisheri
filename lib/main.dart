import 'dart:async';

import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Screens/auth_screen.dart';
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();

  TabController _tabController;
  int _selectedTab = 0;

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
          VenueFormScreen(),
        ],
      ),
    );
  }

  Text _appBarTitle = Text(
    "Fisheri",
    style: TextStyle(color: HouseColors.white, fontSize: 24.0),
  );

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
        title: _appBarTitle,
        backgroundColor: HouseColors.primaryGreen,
        centerTitle: true);

    return MaterialApp(
      home: Scaffold(
        appBar: _appBar,
        body: Stack(
          children: [
            _buildTabContent(),
            BottomTabBar(
              selectedTab: _selectedTab,
              onTap: _tabSelected,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
