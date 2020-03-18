import 'package:fisheri/Screens/detail_screen/detail_screen.dart';
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

  static void pushCupertinoPageRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) => route)
    );
  }

}