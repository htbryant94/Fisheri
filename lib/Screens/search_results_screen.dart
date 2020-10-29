import 'package:fisheri/Components/base_cell.dart';
import 'package:fisheri/Components/distance_indicator.dart';
import 'package:fisheri/Components/list_view_button.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/firestore_request_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/house_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:fisheri/models/venue_search.dart';

class AllVenuesListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirestoreRequestService.defaultService().firestore.collection('venues_search').orderBy("name").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.separated(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.documents.length,
                separatorBuilder: (BuildContext context, int index) {
                  return DSComponents.singleSpacer();
                },
                itemBuilder: (context, int index) {
                  final result =  snapshot.data.documents[index];
                  final VenueSearch venue = VenueSearchJSONSerializer().fromMap(result.data);
                  return EditVenueCell(
                    venue: venue,
                  );
                });
          },
        ),
      ),
    );
  }
}

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen({this.searchResults, this.userCurrentLocation});

  final List<SearchResult> searchResults;
  final GeoPoint userCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            itemCount: searchResults.length,
            separatorBuilder: (BuildContext context, int index) {
            return DSComponents.sectionSpacer();
            },
            itemBuilder: (context, int index) {
              final VenueSearch venue = searchResults[index].venue;
            return SearchResultCell(
              venue: venue,
              layout: BaseCellLayout.cover,
              distanceIndicator: DistanceIndicator(
                  selectedVenueLocation: searchResults[index].geoPoint,
                  userCurrentLocation: userCurrentLocation
              ),
            );
        }),
      ),
    );
  }
}

class ListViewItem {
  ListViewItem({
    this.title,
    this.subtitle,
    this.imageURL,
    this.image,
    this.additionalInformation,
});

  final String title;
  final String subtitle;
  final String imageURL;
  final Image image;
  final List<String> additionalInformation;
}

class ListViewScreen extends StatelessWidget {
  ListViewScreen({
    this.items
});

  final List<ListViewItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.separated(
            itemCount: items.length,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            separatorBuilder: (BuildContext context, int index) {
              return DSComponents.sectionSpacer();
            },
            itemBuilder: (context, int index) {
              final item = items[index];
              if (item.image != null) {
                return NewLocalImageBaseCell(
                  title: item.title,
                  subtitle: item.subtitle,
                  image: item.image,
                  elements: item.additionalInformation.map((info) => HouseTexts.subheading(info)).toList(),
                );
              } else if (item.imageURL != null) {
                return RemoteImageBaseCell(
                  title: item.title,
                  subtitle: item.subtitle,
                  imageURL: item.imageURL,
                  elements: item.additionalInformation.map((info) => HouseTexts.subheading(info)).toList(),
                );
              } else {
                return RemoteImageBaseCell(
                  title: item.title,
                  subtitle: item.subtitle,
                  imageURL: item.imageURL,
                  layout: BaseCellLayout.cover,
                  height: 278,
                  elements: item.additionalInformation.map((info) => HouseTexts.subheading(info)).toList(),
                );
              }
            }
        ),
      ),
    );
  }
}
