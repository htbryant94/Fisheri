import 'package:flutter/material.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:fisheri/result_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen(this.searchResults);

  final List<ResultInfo> searchResults;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('venues_search').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator(); // Add a loading screen here
        return ListView.separated(
          itemCount: snapshot.data.documents.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1, color: Colors.grey[700]),
          itemBuilder: (context, index) {
            final _venueType = snapshot.data.documents[index]['isLake'] ? 'LAKE' : 'SHOP';
            return SearchResultCell(
              imageURL: 'images/lake.jpg',
              title: snapshot.data.documents[index]['name'],
              venueType: _venueType,
              distance: '5 miles',
              isOpen: true,
            );
          },
        );
      },
    );
  }
}
