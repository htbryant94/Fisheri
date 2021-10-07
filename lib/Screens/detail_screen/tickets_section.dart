// @dart=2.9

import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/house_colors.dart';
import 'package:recase/recase.dart';

class TicketsSection extends StatelessWidget {
  TicketsSection({this.tickets});

  final List<dynamic> tickets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HouseTexts.heading('Tickets'),
          SizedBox(height: 8),
          HouseTexts.custom(text:'Prices from: £39', fontSize: 14, fontWeight: FontWeight.w600),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: tickets.map((ticket) => _Ticket(type: ticket)).toList(),
            ),
          ),
          RaisedButton(
            child: Text(
              "Book Now",
              style: TextStyle(color: HouseColors.primaryGreen),
            ),
            color: HouseColors.accentGreen,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class _Ticket extends StatelessWidget {
  _Ticket({
    this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HouseTexts.body('- ${ReCase(type).titleCase}'),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
