import 'package:fisheri/Components/base_cell.dart';
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
            return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.documents.length,
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
  SearchResultsScreen({this.searchResults});

  final List<VenueSearch> searchResults;

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
              final VenueSearch venue = searchResults[index];
            return SearchResultCell(
              venue: venue,
              layout: BaseCellLayout.cover,
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
    return SafeArea(
      child: ListView.builder(
          itemCount: items.length,
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
              return NewLocalImageBaseCell(
                height: 300,
                title: item.title,
                subtitle: item.subtitle,
                image: Image.asset('images/question_mark.png'),
                elements: item.additionalInformation.map((info) => HouseTexts.subheading(info)).toList(),
              );
            }
          }
      ),
    );
  }
}
