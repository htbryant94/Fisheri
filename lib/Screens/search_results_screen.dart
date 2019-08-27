import 'package:flutter/material.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:fisheri/result_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/fish_stock.dart';

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen(this.searchResults);

  final List<ResultInfo> searchResults;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: Firestore.instance.collection('venues_search').snapshots(),
      stream: Firestore.instance.collection('venues_detail').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Add a loading screen here
        }
        return ListView.separated(
          itemCount: snapshot.data.documents.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1, color: Colors.grey[700]),
          itemBuilder: (context, index) {
            final _venueType = snapshot.data.documents[index]['isLake'] ? 'LAKE' : 'SHOP';
            final List<dynamic> _fishStockArray = snapshot.data.documents[index]['fish_stock_array'];
            final List<dynamic> _fishingTypes = snapshot.data.documents[index]['fishing_types_array'];
            final List<dynamic> _amenities = snapshot.data.documents[index]['amenities_array'];
            final Map _openingHours = snapshot.data.documents[index]['hours_of_operation_map'];
            final _address = snapshot.data.documents[index]['address'];
            final List<dynamic> _tickets = snapshot.data.documents[index]['tickets_array'];
            return SearchResultCell(
              imageURL: 'images/lake.jpg',
              title: snapshot.data.documents[index]['name'],
              descriptionText: snapshot.data.documents[index]['description'],
              venueType: _venueType,
              distance: '5 miles',
              isOpen: true,
              address: VenueAddressJSONSerializer().fromMap(_address),
              openingHours: HoursOfOperationJSONSerializer().fromMap(_openingHours),
              amenities: _amenities,
              // fishStock: VenueFishStockJSONSerializer().fromMap(_fishStock),
              fishStock: _fishStockArray,
              fishTypes: _fishingTypes,
              tickets: _tickets,
            );
          },
        );
      },
    );
  }


}
