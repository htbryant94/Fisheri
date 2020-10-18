
import 'package:flutter/material.dart';
import '../design_system.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 260,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12),
                offset: Offset(6,12),
                blurRadius: 16
            )
          ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DSComponents.body(text: "Where are you going?"),
            Image.asset('images/icons/filter.png', height: 24, width: 24),
          ],
        ),
      ),
    );
  }
}