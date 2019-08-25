import 'package:fisheri/house_colors.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/fish_stock.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/button_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/Screens/detail_screen/amenities_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_types_section.dart';
import 'package:fisheri/Screens/detail_screen/fish_stocked_section.dart';

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
        FishStockedSection(fishStock),
        FishingTypesSection(fishTypes),
        AmenitiesSection(amenities),
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
