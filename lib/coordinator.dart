import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/list_view_button.dart';
import 'package:fisheri/Screens/auth_screen.dart';
import 'package:fisheri/Screens/catch_detail_screen.dart';
import 'package:fisheri/Screens/catch_form_edit_screen.dart';
import 'package:fisheri/Screens/catch_report_screen.dart';
import 'package:fisheri/Screens/detail_screen/detail_screen.dart';
import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'Screens/search_results_screen.dart';

class Coordinator {

  static void pushSearchResultsScreen(BuildContext context, String currentPageTitle, {List<SearchResult> venues, GeoPoint userCurrentLocation}) {
    Navigator.push(context,
        CupertinoPageRoute(
          builder: (context) =>
              CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  previousPageTitle: currentPageTitle,
                  middle: Text('${venues.length} ' + (venues.length == 1 ? 'Result' : 'Results')),
                ),
                child: SearchResultsScreen(searchResults: venues, userCurrentLocation: userCurrentLocation),
              ),
        ));
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

  static void pushVenueDetailScreen(BuildContext context, String currentPageTitle, VenueDetailed venue, String imageURL) {
    presentCupertinoPageRoute(context,
    CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
      ),
      child: DetailScreen(venue: venue, imageURL: imageURL),
    ));
  }

  static void pushCatchReportScreen(BuildContext context, {String currentPageTitle, DateTime startDate, DateTime endDate, String id }) {
    pushCupertinoPageRoute(context,
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: currentPageTitle,
          middle: Text('Your Catches'),
        ),
        child: CatchReportScreen(
          startDate: startDate,
          endDate: endDate,
          id: id,
        ),
      )
    );
  }

  static void pushCatchDetailScreen(BuildContext context, {String currentPageTitle, Catch catchData}) {
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
                    screen: CatchFormEditScreen(
                      catchData: catchData,
                    ),
                    screenTitle: 'New Catch'
                );
              },
            ),
          ),
          child: CatchDetailScreen(
            data: catchData,
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