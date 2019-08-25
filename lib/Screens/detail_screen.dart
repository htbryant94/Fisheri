import 'package:fisheri/house_colors.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/fish_stock.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/button_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(this.descriptionExpanded, this.title, this.fishStock,
      this.amenities, this.fishTypes);

  final bool descriptionExpanded;
  final String title;
  final List<dynamic> fishStock;
  final List<dynamic> amenities;
  final List<dynamic> fishTypes;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ImageCarousel('images/lake.jpg'),
        TitleSection(
          title: title,
          subtitle: 'Biggleswade, Hertfordshire',
        ),
        DescriptionSection(descriptionExpanded),
        ButtonSection(Colors.blue),
        SizedBox(height: 16),
        _FishStockedSection(fishStock),
        _FishingTypesSection(fishTypes),
        _AmenitiesSection(amenities),
        _Tickets(),
        _OpeningHours(),
        _FishingRules(true),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  _Header(this.header);

  final String header;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(header,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
  }
}



class _GridItem extends StatelessWidget {
  _GridItem({this.item, this.image, this.width});

  final String item;
  final Image image;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: Column(children: [
          AspectRatio(aspectRatio: 1.5, child: image),
          SizedBox(height: 8),
          Text(item, textAlign: TextAlign.center)
        ]));
  }
}

class _AmenitiesSection extends StatelessWidget {
  _AmenitiesSection(this.amenities);

  final List<dynamic> amenities;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        children: [
          _Header('Amenities'),
          const SizedBox(height: 16),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: amenities
                  .map((amenity) => _AmenitiesGridItem(amenity))
                  .toList())
        ],
      ),
    );
  }
}

class _AmenitiesGridItem extends StatelessWidget {
  _AmenitiesGridItem(this.amenity);

  final String amenity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: _Amenity(amenity));
  }
}

class _Amenity extends StatelessWidget {
  _Amenity(this.amenity);

  final String amenity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(Icons.person), Text(amenity)],
    );
  }
}

class _FishingTypesSection extends StatelessWidget {
  _FishingTypesSection(this.fishTypes);

  final List<dynamic> fishTypes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        children: [
          _Header('Fishing Types'),
          const SizedBox(height: 16),
          Wrap(
              spacing: 16,
              runSpacing: 16,
              children: fishTypes
                  .map((types) => _FishingTypeGridItem(types))
                  .toList())
        ],
      ),
    );
  }
}

class _FishingTypeGridItem extends StatelessWidget {
  _FishingTypeGridItem(this.type);

  final String type;

  @override
  Widget build(BuildContext context) {
    final storageURL = 'gs://fishing-finder-594f0.appspot.com/fishing/types/';
    final actualURL = "$storageURL$type.jpg";

    return _GridItem(
      item: type,
      image: Image(image: FirebaseStorageImage(actualURL)),
      width: 120,
    );
  }
}

class _FishStockedSection extends StatelessWidget {
  _FishStockedSection(this.fishStock);

  final List<dynamic> fishStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        children: [
          _Header('Fish Stocked'),
          const SizedBox(height: 16),
          Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  fishStock.map((fish) => _FishStockedGridItem(fish)).toList())
        ],
      ),
    );
  }
}

class _FishStockedGridItem extends StatelessWidget {
  _FishStockedGridItem(this.fish);

  final String fish;

  @override
  Widget build(BuildContext context) {
    final storageURL = 'gs://fishing-finder-594f0.appspot.com/fish/stock/';
    final fishURL = fish.replaceAll(" ", "_").toLowerCase();
    final actualURL = "$storageURL$fishURL.png";

    return _GridItem(
      item: fish,
      image: Image(image: FirebaseStorageImage(actualURL)),
      width: 65,
    );
  }
}

class _Tickets extends StatelessWidget {
  _Tickets();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: <Widget>[
            _Header('Tickets'),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text('Day', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            ),
            Row(
              children: <Widget>[
                Text('Syndicate',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            ),
            Row(
              children: <Widget>[
                Text('Season', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            ),
            Row(
              children: <Widget>[
                Text('Club', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            )
          ],
        ));
  }
}

class _OpeningHoursRow extends StatelessWidget {
  _OpeningHoursRow(this.day, this.openTime, this.closeTime);

  final String day;
  final String openTime;
  final String closeTime;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(day),
          Text('$openTime - $closeTime'),
        ]);
  }
}

class _OpeningHours extends StatelessWidget {
  _OpeningHours();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Column(children: <Widget>[
        _Header('Opening Hours'),
        SizedBox(height: 16),
        _OpeningHoursRow('Monday', '09:00', '22:00'),
        _OpeningHoursRow('Tuesday', '09:00', '22:00'),
        _OpeningHoursRow('Wednesday', '09:00', '22:00'),
        _OpeningHoursRow('Thursday', '09:00', '22:00'),
        _OpeningHoursRow('Friday', '09:00', '22:00'),
        _OpeningHoursRow('Saturday', '09:00', '22:00'),
        _OpeningHoursRow('Sunday', '09:00', '22:00'),
      ]),
    );
  }
}

class _FishingRules extends StatelessWidget {
  _FishingRules(this.isExpanded);

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    FlatButton readMoreButton = FlatButton(
        child: Text("Read More", style: TextStyle(color: Colors.blue)),
        onPressed: () {
          print(isExpanded);
          // descriptionExpanded = !descriptionExpanded;
        });

    Text textBody = Text(
      'When and where you can fish National close season rules for coarse fishing apply across the Anglian region. The coarse fishing close season between 15 March and 15 June applies to all rivers, streams, drains, the Norfolk Broads and some stillwaters. Dates are inclusive All dates mentioned in these byelaws are inclusive: this means a stated period, such as 15 March to 15 June, includes the full day of 15 March and the full day of 15 June. Salmon and migratory trout The close season for salmon and migratory trout (in all waters) is 29 September to the last day of February. There is also a weekly close time from 6am on Sunday to midnight on the following day. A small number of rivers in Anglia have been canalised (converted into canals), and remain subject to the national close season: Fossdyke Canal, Louth Canal, Horncastle Canal and the Dilham and North Walsham Canal.',
      softWrap: true,
      overflow: TextOverflow.fade,
      maxLines: isExpanded ? 8 : 4,
    );

    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(children: [
          _Header('Fishing Rules'),
          SizedBox(height: 16),
          textBody,
          readMoreButton
        ]));
  }
}
