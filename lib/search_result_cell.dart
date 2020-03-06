import 'package:flutter/material.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/fish_stock.dart';
import 'Screens/detail_screen/detail_screen.dart';
import 'house_colors.dart';

class SearchResultCell extends StatelessWidget {
  SearchResultCell({
    this.imageURL,
    this.title,
    this.descriptionText,
    this.venueType,
    this.isOpen,
    this.distance,
    this.fishStock,
    this.address,
    this.openingHours,
    this.amenities,
    this.fishTypes,
    this.tickets,
    this.fishingRules,
    this.index,
  });

  final String imageURL;
  final String title;
  final String descriptionText;
  final String venueType;
  final bool isOpen;
  final String distance;
  final List<dynamic> fishStock;
  final VenueAddress address;
  final HoursOfOperation openingHours;
  final List<dynamic> amenities;
  final List<dynamic> fishTypes;
  final List<dynamic> tickets;
  final String fishingRules;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondRoute(
                      title: title,
                      descriptionText: descriptionText,
                      fishStock: fishStock,
                      fishTypes: fishTypes,
                      amenities: amenities,
                      openingHours: openingHours,
                      address: address,
                      tickets: tickets,
                      fishingRules: fishingRules,
                      index: index,
                    )));
      },
      child: Container(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchResultCellImage(
              imageURL: imageURL,
              index: index,),
            _SearchResultCellInfo(
              title: title,
              venueType: venueType,
              isOpen: isOpen,
              distance: distance,
              index: index,
            )
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  SecondRoute({
    this.title,
    this.descriptionText,
    this.fishStock,
    this.amenities,
    this.fishTypes,
    this.openingHours,
    this.address,
    this.tickets,
    this.fishingRules,
    this.index,
  });

  final String title;
  final String descriptionText;
  final List<dynamic> fishStock;
  final List<dynamic> amenities;
  final List<dynamic> fishTypes;
  final HoursOfOperation openingHours;
  final VenueAddress address;
  final List<dynamic> tickets;
  final String fishingRules;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: HouseColors.primaryGreen,
      ),
      body: Center(
        child: DetailScreen(
          title: title,
          descriptionText: descriptionText,
          fishTypes: fishTypes,
          fishStock: fishStock,
          amenities: amenities,
          openingHours: openingHours,
          descriptionExpanded: true,
          address: address,
          tickets: tickets,
          fishingRules: fishingRules,
          index: index,
        ),
      ),
    );
  }
}

class _SearchResultCellImage extends StatelessWidget {
  _SearchResultCellImage({
    this.imageURL,
    this.index,
  });

  final String imageURL;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'HeroImage_$index',
        child: AspectRatio(
          child: Image.asset(imageURL, fit: BoxFit.fill),
          aspectRatio: 1.0,
        ));
    // return Image.asset(imageURL, fit: BoxFit.fill);
  }
}

class _SearchResultCellInfo extends StatelessWidget {
  _SearchResultCellInfo({
    Key key,
    this.title,
    this.venueType,
    this.distance,
    this.isOpen,
    this.index,
  }) : super(key: key);

  final String title;
  final String venueType;
  final String distance;
  final bool isOpen;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Hero(child: _Title(title), tag: 'HeroTitle_$index'),
                  _VenueType(venueType),
                  _VenueOperational(isOpen),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _VenueFeatures(),
                      _VenueDistance(distance),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}

class _VenueType extends StatelessWidget {
  _VenueType(this.venueType);

  final String venueType;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$venueType',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 14, color: Colors.black87),
    );
  }
}

class _VenueOperational extends StatelessWidget {
  _VenueOperational(this.isOpen);

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${isOpen ? "Open" : "Closed"}',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isOpen ? Colors.green : Colors.red,
      ),
    );
  }
}

class _VenueFeatures extends StatelessWidget {
  // _VenueFeatures(this.features);

  // final List<Icon> features;

  @override
  Widget build(BuildContext context) {
    const double _spacing = 4;
    return Row(
      children: [
        Icon(Icons.directions_boat),
        SizedBox(width: _spacing),
        Icon(Icons.directions_bike),
        SizedBox(width: _spacing),
        Icon(Icons.add_location),
        SizedBox(width: _spacing),
        Icon(Icons.description),
      ],
    );
  }
}

class _VenueDistance extends StatelessWidget {
  _VenueDistance(this.distance);

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$distance',
      style: const TextStyle(
        fontSize: 12,
        fontStyle: FontStyle.italic,
        color: Colors.black87,
      ),
    );
  }
}
