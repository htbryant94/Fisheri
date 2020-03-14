import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:fisheri/models/venue_search.dart';

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen({this.searchResults});

  final List<VenueSearch> searchResults;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, int index) {
            final VenueSearch venue = searchResults[index];
            return SearchResultCell(
              venue: venue,
            );
      }),
    );
  }
}
