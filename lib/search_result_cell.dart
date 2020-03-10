import 'package:flutter/material.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'Screens/detail_screen/detail_screen.dart';
import 'Components/base_cell.dart';
import 'house_colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
      child: BaseCell(
        title: title,
        subtitle: venueType,
        image: Image.asset('images/lake.jpg'),
        elements: <Widget>[
          _VenueOperational(true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _VenueFeatures(),
              _VenueDistance(distance),
            ],
          )
        ],
      )
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

class _VenueOperational extends StatelessWidget {
  _VenueOperational(this.isOpen);

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${isOpen ? "Open" : "Closed"}',
      style: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        color:isOpen ? Colors.green : Colors.red,
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
      style: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: Colors.black,
      ),
    );
  }
}
