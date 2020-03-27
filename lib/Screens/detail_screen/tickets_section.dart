import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/house_colors.dart';

class TicketsSection extends StatelessWidget {
  TicketsSection({this.tickets});

  final List<dynamic> tickets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Column(
        children: [
          HouseTexts.heading('Tickets'),
          SizedBox(height: 8),
          Column(
            children: tickets.map((ticket) => _Ticket(type: ticket)).toList(),
          ),
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
    return Row(
      children: [
        Text(type, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        Text('Price from: £39'),
        Spacer(),
        RaisedButton(
          child: Text(
            "See more",
            style: TextStyle(color: HouseColors.primaryGreen),
          ),
          color: HouseColors.accentGreen,
          onPressed: () {},
        )
      ],
    );
  }
}
