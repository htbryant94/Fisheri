import 'package:fisheri/Screens/catch_report/catch_reports_screen.dart';
import 'package:fisheri/Screens/holiday_countries_screen.dart';
import 'package:fisheri/Screens/profile_screen.dart';
import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/auth_screen.dart';
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

  TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
    return TabBarView(
      controller: _tabController,
      children: [
        AuthScreen(),
        CatchReportsScreen(),
        SearchScreen(),
        SearchResultsScreen(),
        VenueFormScreen(),
      ],
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

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(icon: Icon(Icons.description), title: Text('Catch')),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), title: Text('Holidays')),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Profile')),
//          BottomNavigationBarItem(icon: Icon(Icons.assignment), title: Text('Venue')),
//          BottomNavigationBarItem(icon: Icon(Icons.explore), title: Text('Login')),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SearchScreen(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Your Catch Reports'),
                ),
                child: CatchReportsScreen(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Holidays'),
                ),
                child: HolidayCountriesScreen(),
              );
            });
          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ProfileScreen(),
              );
            });
          default:
            return Container();
        };
      },
    );
  }
}
