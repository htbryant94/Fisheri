// @dart=2.9

import 'package:fisheri/Components/FilterDistancePill.dart';
import 'package:fisheri/Components/base_cell.dart';
import 'package:fisheri/Components/distance_indicator.dart';
import 'package:fisheri/Components/fisheri_icon_button.dart';
import 'package:fisheri/Components/list_view_button.dart';
import 'package:fisheri/Screens/holiday_detail_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/firestore_request_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/models/holiday_detailed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/rendering.dart';

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
                itemCount: snapshot.data.docs.length,
                separatorBuilder: (BuildContext context, int index) {
                  return DSComponents.singleSpacer();
                },
                itemBuilder: (context, int index) {
                  final result =  snapshot.data.docs[index];
                  final venue = VenueSearch.fromJson(result.data());
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
  SearchResultsScreen({
    this.searchResults,
    this.userCurrentLocation,
    this.searchRadius,
    this.searchTown,
  });

  final List<SearchResult> searchResults;
  final GeoPoint userCurrentLocation;
  final double searchRadius;
  final String searchTown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
              child: Column(
                children: [
                  _SearchHeader(
                    town: searchTown,
                    distance: searchRadius / 1.609344,
                    resultsCount: searchResults.length,
                  ),
                  DSComponents.doubleSpacer(),
                  Expanded(
                    child: ListView.separated(
                        itemCount: searchResults.length,
                        separatorBuilder: (BuildContext context, int index) {
                        return DSComponents.sectionSpacer();
                        },
                        itemBuilder: (context, int index) {
                        final venue = searchResults[index].venue;
                        // if (index > 0 && index % 5 == 0) {
                          // return AdvertCell();
                        // } else {
                          return SearchResultCell(
                            venue: venue,
                            layout: BaseCellLayout.cover,
                            userCurrentPosition: userCurrentLocation,
                            distanceIndicator: DistanceIndicator(
                                selectedVenueLocation: searchResults[index].geoPoint,
                                userCurrentLocation: userCurrentLocation
                            ),
                          );
                        // }
                    }),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 24,
                right: 16,
                child: Container(
                  height: 44,
                  width: 44,
                  child: FisheriIconButton(
                    icon: Icon(Icons.map_outlined, color: Colors.white),
                    onTap:  Navigator.of(context).pop,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class AdvertCell extends StatelessWidget {
  const AdvertCell({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.asset(
        'images/placeholders/environment_banner.png',
        fit: BoxFit.fill,
      ),
      decoration: BoxDecoration(
        color: DSColors.green,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DSColors.grey.withOpacity(0.5), width: 0.5),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  _SearchHeader({
    this.town,
    this.distance,
    this.resultsCount = 0,
});

  final String town;
  final double distance;
  final int resultsCount;

  @override
  Widget build(BuildContext context) {
    final items = [
      if (town != null)
        DSComponents.body(text: town),
      if (distance != null)
        distance.truncate() != 1000 ? FilterDistancePill(distance: distance, showPlus: true) : DSComponents.body(text: 'Nationwide'),
      if (resultsCount > 1)
      DSComponents.body(text: '$resultsCount results'),
    ];

    return Column(
      children: [
        DSComponents.titleLarge(text: 'Search'),
        DSComponents.singleSpacer(),
        if (town != null || distance != null || resultsCount > 1)
        Container(
          height: 26,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index];
            },
            separatorBuilder: (context, _) {
                return Row(
                  children: [
                    DSComponents.singleSpacer(),
                    DSComponents.body(text: '•'),
                    DSComponents.singleSpacer(),
                  ],
                );
            },
          ),
        ),
      ],
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
    this.venue,
    this.isSponsored = false
});

  final String title;
  final String subtitle;
  final String imageURL;
  final Image image;
  final List<String> additionalInformation;
  final HolidayDetailed venue;
  final bool isSponsored;
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
                return GestureDetector(
                  onTap: () {
                    Coordinator.present(context, screenTitle: 'Holiday', currentPageTitle: 'France', screen: HolidayDetailScreen(venue: item.venue));
                  },
                  child: NewLocalImageBaseCell(
                    title: item.title,
                    subtitle: item.subtitle,
                    image: item.image,
                    elements: item.additionalInformation.map((info) => DSComponents.body(text: info)).toList(),
                  ),
                );
              } else if (item.imageURL != null) {
                return GestureDetector(
                  onTap: () {
                    Coordinator.present(context, screenTitle: 'Holiday', currentPageTitle: 'France', screen: HolidayDetailScreen(venue: item.venue));
                  },
                  child: RemoteImageBaseCell(
                    title: item.title,
                    subtitle: item.subtitle,
                    imageURL: item.imageURL,
                    layout: BaseCellLayout.cover,
                    height: 278,
                    elements: item.additionalInformation.map((info) => DSComponents.body(text: info)).toList(),
                    isSponsored: item.isSponsored,
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Coordinator.present(context, screenTitle: 'Holiday', currentPageTitle: 'France"', screen: HolidayDetailScreen(venue: item.venue));
                  },
                  child: RemoteImageBaseCell(
                    title: item.title,
                    subtitle: item.subtitle,
                    imageURL: item.imageURL,
                    layout: BaseCellLayout.cover,
                    height: 278,
                    elements: item.additionalInformation.map((info) => DSComponents.body(text: info)).toList(),
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}
