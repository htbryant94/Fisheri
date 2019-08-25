import 'package:flutter/material.dart';
import 'header.dart';
import 'package:fisheri/house_colors.dart';

class TicketsSection extends StatelessWidget {
  TicketsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: <Widget>[
            Header('Tickets'),
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
