import 'package:flutter/material.dart';
import 'Screens/detail_screen.dart';
import 'house_colors.dart';

class SearchResultCell extends StatelessWidget {
  SearchResultCell({
    Key key,
    this.imageURL,
    this.title,
    this.venueType,
    this.isOpen,
    this.distance,
  }) : super(key: key);

  final String imageURL;
  final String title;
  final String venueType;
  final bool isOpen;
  final String distance;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped");
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => SecondRoute(title))
        );
      },
      child: Container(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchResultCellImage(imageURL),
            _SearchResultCellInfo(
              title: title,
              venueType: venueType,
              isOpen: isOpen,
              distance: distance,
            )
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  SecondRoute(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: HouseColors.primaryGreen,
      ),
      body: Center(
        child: DetailScreen(true, title),
      ),
    );
  }
}

class _SearchResultCellImage extends StatelessWidget {
  _SearchResultCellImage(this.imageURL);

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      child: Image.asset(imageURL, fit: BoxFit.fill),
      aspectRatio: 1.0,
    );
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
  }) : super(key: key);

  final String title;
  final String venueType;
  final String distance;
  final bool isOpen;

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
                  _Title(title),
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
