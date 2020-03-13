import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'Screens/search_results_screen.dart';

class Coordinator {

  static void pushSearchResultsScreen(BuildContext context, String currentPageTitle) {
    Navigator.push(context,
        CupertinoPageRoute(
          builder: (context) =>
              CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  previousPageTitle: currentPageTitle,
                  middle: Text('Search Results'),
                ),
                child: SearchResultsScreen(),
              ),
        ));
  }

}