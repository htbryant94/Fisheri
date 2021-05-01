import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fisheri/Screens/catch_report/catch_reports_screen.dart';
import 'package:fisheri/Screens/holiday_countries_screen.dart';
import 'package:fisheri/Screens/profile_screen.dart';
import 'package:fisheri/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/auth_screen.dart';
import 'Screens/search_screen.dart';
import 'fonts/custom_icons_icons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _shouldShowAuthScreen = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    auth
        .authStateChanges()
        .listen((User user) {
          if (user != null) {
            print('user: ${user.email}');
            _shouldShowAuthScreen = false;
          } else {
            _shouldShowAuthScreen = true;
          }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            activeColor: DSColors.green,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(CustomIcons.fishing), label: 'Catch'),
              BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Holidays'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
            ],
          ),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return SafeArea(
                  child: CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: SearchScreen(),
                    );
                  }),
                );
              case 1:
                return SafeArea(
                  child: CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        middle: Text('Your Catch Reports'),
                      ),
                      child: Stack(
                        children: [
                          CatchReportsScreen(),
                          Visibility(
                              visible: _shouldShowAuthScreen,
                              child: CupertinoPageScaffold(child: AuthScreen())
                          ),
                        ],
                      ),
                    );
                  }),
                );
              case 2:
                return SafeArea(
                  child: CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        middle: Text('Holidays'),
                      ),
                      child: HolidayCountriesScreen(),
                    );
                  }),
                );
              case 3:
                return SafeArea(
                  child: CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: ProfileScreen(),
                    );
                  }),
                );
              default:
                return Container();
            };
          },
        ),
      ],
    );
  }
}
