
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../design_system.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    this.onChanged,
  }) : super(key: key);

  final ValueChanged<String> onChanged;

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
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Where are you going?",
                  hintStyle: DesignSystemFonts.body(DSColors.grey),
                  border: InputBorder.none,
                ),
                style: DesignSystemFonts.body(DSColors.black),
                onChanged: onChanged,
              ),
            ),
            Image.asset('images/icons/filter.png', height: 24, width: 24),
          ],
        ),
      ),
    );
  }
}