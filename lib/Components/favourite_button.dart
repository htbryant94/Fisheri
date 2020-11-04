import 'package:flutter/material.dart';

import '../design_system.dart';

class FavouriteButton extends StatefulWidget {
  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  var isEnabled = false;

  Icon _filled() {
    return Icon(Icons.favorite, color: Colors.pink, size: 32);
  }

  Icon _unfilled() {
    return Icon(Icons.favorite_border, color: Colors.white, size: 32);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print("heart tapped");
          setState(() {
            isEnabled = !isEnabled;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(offset: Offset(0,4), blurRadius: 4, color: DSColors.black.withOpacity(0.25))
              ]
          ),
          child: isEnabled ? _filled() : _unfilled(),
        )
    );
  }
}