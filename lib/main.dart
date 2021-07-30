import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fisheri/Screens/catch_report/catch_reports_screen.dart';
import 'package:fisheri/Screens/catch_report_screen.dart';
import 'package:fisheri/Screens/profile_screen.dart';
import 'package:fisheri/Screens/search_results_screen.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/routes/arguments/catch_report_screen_arguments.dart';
import 'package:fisheri/routes/fisheri_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'Screens/auth_screen.dart';
import 'Screens/search_screen.dart';
import 'fonts/custom_icons_icons.dart';
import 'holiday_data.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Google Maps Demo',
      home: HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case CatchReportScreen.routeName:
            final args = settings.arguments as CatchReportScreenArguments;
            return FisheriRoute.catchReport(args.catchReport, args.catchReportID);

          default:
            return null;
        }
      },
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
              BottomNavigationBarItem(icon: Icon(CustomIcons.search, size: 24), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(CustomIcons.fishing, size: 24), label: 'Catch'),
              // BottomNavigationBarItem(icon: Icon(CustomIcons.sunset, size: 24), label: 'Holidays'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, size: 24), label: 'Profile',),
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
                          if (!_shouldShowAuthScreen)
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

class HolidaysTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoTabView(builder: (context) {
        var _items = HolidayData.franceResults.map(
                (holiday) => ListViewItem(
                title: holiday.name,
                imageURL: holiday.images != null ? holiday.images.first : null,
                subtitle: '🇫🇷 ${holiday.country}',
                additionalInformation: [
                  'From Calais: ${holiday.distanceFromCalais} miles',
                  ReCase(describeEnum(holiday.difficulty)).titleCase,
                ],
                venue: holiday,
                isSponsored: holiday.isSponsored
            )
        ).toList();

        _items += HolidayData.belgiumResults.map(
                (holiday) => ListViewItem(
                title: holiday.name,
                imageURL: holiday.images != null ? holiday.images.first : null,
                subtitle: '🇧🇪 ${holiday.country}',
                additionalInformation: [
                  'From Calais: ${holiday.distanceFromCalais} miles',
                  ReCase(describeEnum(holiday.difficulty)).titleCase,
                ],
                venue: holiday
            )
        ).toList();

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Holidays'),
          ),
          child: ListViewScreen(items: _items),
        );
      }),
    );
  }
}

