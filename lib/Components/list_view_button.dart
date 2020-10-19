import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/material.dart';

import '../coordinator.dart';
import '../design_system.dart';

class ListViewButton extends StatefulWidget {
  ListViewButton({this.venues});

  @required
  final List<VenueSearch> venues;

  @override
  ListViewButtonState createState() => ListViewButtonState();
}

class ListViewButtonState extends State<ListViewButton> {
  Color _color = DSColors.black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (tapDetails) {
        if (widget.venues != null) {
          Coordinator.pushSearchResultsScreen(context, 'Map', widget.venues);
        }
        setState(() {
          _color = DSColors.black;
        });
      },
      onTapDown: (tapDetails) {
        setState(() {
          _color = DSColors.green;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: _color,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.36),
                  offset: Offset(4,8),
                  blurRadius: 16
              )
            ]
        ),
        padding: EdgeInsets.all(12),
        child: Image.asset(
          'images/icons/list.png',
          color: Colors.white,
        ),
      ),
    );
  }
}