import 'package:fisheri/Screens/auth_screen.dart';
import 'package:fisheri/Screens/catch_detail_screen.dart';
import 'package:fisheri/Screens/catch_report_screen.dart';
import 'package:fisheri/Screens/detail_screen/detail_screen.dart';
import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'models/venue_search.dart';

import 'Screens/search_results_screen.dart';

class Coordinator {

  static void pushSearchResultsScreen(BuildContext context, String currentPageTitle, List<VenueSearch> venues) {
    Navigator.push(context,
        CupertinoPageRoute(
          builder: (context) =>
              CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  previousPageTitle: currentPageTitle,
                  middle: Text('Search Results'),
                ),
                child: SearchResultsScreen(searchResults: venues),
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
    pushCupertinoPageRoute(context,
    CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: currentPageTitle,
        middle: Text(venue.name),
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

  static void push(BuildContext context, {String currentPageTitle, String screenTitle, Widget screen}) {
    pushCupertinoPageRoute(context,
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: currentPageTitle,
            middle: Text(screenTitle),
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
  
}