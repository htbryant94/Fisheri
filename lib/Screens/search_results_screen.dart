import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/models/venue_detailed.dart' as prefix0;
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
            final _venue = snapshot.data.documents[index];
            final _venueDetailed = VenueDetailed(
              name: _venue['name'],
              isLake: _venue['isLake'],
              isShop: _venue['isShop'],
              description: _venue['description'],
              social: SocialJSONSerializer().fromMap(_venue['social']),
              address: VenueAddressJSONSerializer().fromMap(_venue['address']),
              fishingTypes: _venue['fishing_types_array'],
              fishStocked: _venue['fish_stock_array'],
              amenities: _venue['amenities_array'],
              tickets: _venue['tickets_array'],
            );

            final _venueType = snapshot.data.documents[index]['isLake'] ? 'LAKE' : 'SHOP';
            final Map _openingHours = snapshot.data.documents[index]['hours_of_operation_map'];
            return SearchResultCell(
              imageURL: 'images/lake.jpg',
              title: snapshot.data.documents[index]['name'],
              descriptionText: snapshot.data.documents[index]['description'],
              venueType: _venueType,
              distance: '5 miles',
              isOpen: true,
              address: _venueDetailed.address,
              openingHours: HoursOfOperationJSONSerializer().fromMap(_openingHours),
              amenities: _venueDetailed.amenities,
              fishStock: _venueDetailed.fishStocked,
              fishTypes: _venueDetailed.fishingTypes,
              tickets: _venueDetailed.tickets,
            );
          },
        );
      },
    );
  }


}
