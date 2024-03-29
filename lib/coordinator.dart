// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/list_view_button.dart';
import 'package:fisheri/Screens/auth_screen.dart';
import 'package:fisheri/Screens/catch_detail_screen.dart';
import 'package:fisheri/Screens/catch_form_screen.dart';
import 'package:fisheri/Screens/catch_report_screen.dart';
import 'package:fisheri/Screens/detail_screen/detail_screen.dart';
import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'Screens/catch_report_form_screen.dart';
import 'Screens/search_results_screen.dart';

class Coordinator {

  static void searchResultsScreen({
    BuildContext context,
    String currentPageTitle,
    List<SearchResult> venues,
    GeoPoint userCurrentLocation,
    double searchRadius,
    String searchTown,
  }) {
    Coordinator.present(
      context,
      screen: SearchResultsScreen(
        searchResults: venues,
        userCurrentLocation: userCurrentLocation,
        searchRadius: searchRadius,
        searchTown: searchTown,
      ),
      showNavigationBar: false,
    );
  }

  static void pushListViewScreen(BuildContext context, {String currentPageTitle, String nextPageTitle, List<ListViewItem> items}) {
    Navigator.push(context,
        CupertinoPageRoute(
          builder: (context) =>
              CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  previousPageTitle: currentPageTitle,
                  middle: Text(nextPageTitle),
                ),
                child: ListViewScreen(items: items),
              ),
        ));
  }

  static void pushVenueDetailScreen(
      BuildContext context,
      String currentPageTitle,
      VenueDetailed venue,
      String imageURL,
      String id,
      GeoPoint userCurrentLocation,
      ) {
    presentCupertinoPageRoute(context,
    CupertinoPageScaffold(
      child: DetailScreen(
        venue: venue,
        imageURL: imageURL,
        id: id,
        userCurrentLocation: userCurrentLocation,
      ),
    ));
  }

  static void pushCatchReportScreen(BuildContext context, {String currentPageTitle, CatchReport catchReport, String catchReportID}) {
    pushCupertinoPageRoute(context,
      CatchReportScreenWrapper(
        catchReport: catchReport,
        catchReportID: catchReportID,
      )
    );
  }

  static void pushCatchDetailScreen({
    BuildContext context,
    String currentPageTitle,
    Catch catchData,
    String catchID,
    CatchReport catchReport,
    String catchReportID,
  }) {
    pushCupertinoPageRoute(context,
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: currentPageTitle,
            middle: Text('Your Catch'),
            trailing: CupertinoButton(
              child: Icon(Icons.edit),
              padding: EdgeInsets.all(8),
              onPressed: () {
                Coordinator.push(
                    context,
                    currentPageTitle: 'Your Catch',
                    screen: CatchFormScreen(
                      catchData: catchData,
                      catchID: catchID,
                      catchReport: catchReport,
                      catchReportID: catchReportID,
                    ),
                    screenTitle: 'Amend Catch'
                );
              },
            ),
          ),
          child: CatchDetailScreen(
            data: catchData,
            catchID: catchID,
          )
        )
    );
  }

  static void pushVenueFormScreen(BuildContext context, {String currentPageTitle, Catch catchData}) {
    pushCupertinoPageRoute(context,
        CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              previousPageTitle: currentPageTitle,
              middle: Text('Add Venue'),
            ),
            child: VenueFormScreen(),
        )
    );
  }

  static void pushAuthScreen(BuildContext context, {String currentPageTitle, Catch catchData}) {
    pushCupertinoPageRoute(context,
        CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              previousPageTitle: currentPageTitle,
              middle: Text('Authentication'),
            ),
            child: AuthScreen(),
        )
    );
  }

  static void push(BuildContext context, {String currentPageTitle, @required String screenTitle, Widget screen, Widget navBarIcon}) {
    pushCupertinoPageRoute(context,
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: currentPageTitle,
            middle: Text(screenTitle),
            trailing: navBarIcon,
          ),
          child: screen,
        )
    );
  }

  static void present(
      BuildContext context,
      {
        String currentPageTitle,
        String screenTitle,
        Widget screen,
        Widget navBarIcon,
        bool showNavigationBar = true
      }) {

    presentCupertinoPageRoute(context,
        CupertinoPageScaffold(
          navigationBar: showNavigationBar ? CupertinoNavigationBar(
            previousPageTitle: currentPageTitle,
            middle: screenTitle != null ? Text(screenTitle) : null,
            trailing: navBarIcon,
          ) : null,
          child: screen,
        )
    );
  }

  static void pushCupertinoPageRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) => route)
    );
  }
  
  static void presentCupertinoPageRoute(BuildContext context, Widget route) {
    Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => route)
    );
  }
  
}

class CatchReportScreenWrapper extends StatefulWidget {
  CatchReportScreenWrapper({
    this.catchReportID,
    this.catchReport
});

  final String catchReportID;
  final CatchReport catchReport;

  @override
  _CatchReportScreenWrapperState createState() => _CatchReportScreenWrapperState();
}

class _CatchReportScreenWrapperState extends State<CatchReportScreenWrapper> {
  CatchReport _currentCatchReport;

  @override
  void initState() {
    _currentCatchReport = widget.catchReport;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: '',
        middle: Text('Catch Report'),
        trailing: CupertinoButton(
          child: Icon(Icons.edit),
          padding: EdgeInsets.all(8),
          onPressed: () {
            Coordinator.present(
                context,
                currentPageTitle: '',
                screen: CatchReportFormScreen(
                  catchReport: _currentCatchReport,
                  catchReportID: widget.catchReportID,
                  onFormSubmitted: (catchReport) {
                    setState(() {
                      _currentCatchReport = catchReport;
                    });
                  },
                ),
                screenTitle: 'Amend Catch Report'
            );
          },
        ),
      ),
      child: CatchReportScreen(
        catchReport: _currentCatchReport,
        catchReportID: widget.catchReportID,
      ),
    );
  }
}
