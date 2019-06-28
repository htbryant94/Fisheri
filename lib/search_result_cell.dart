import 'package:flutter/material.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(Icons.directions_boat),
        Icon(Icons.directions_bike),
        Icon(Icons.directions_car),
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

class SearchResultCell extends StatelessWidget {
  SearchResultCell({
    Key key,
    this.title,
    this.venueType,
    this.distance,
    this.isOpen,
  }) : super(key: key);

  final String title;
  final String venueType;
  final String distance;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Title(title),
              _VenueType(venueType),
              _VenueOperational(isOpen),
              Row(
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
    );
  }
}
