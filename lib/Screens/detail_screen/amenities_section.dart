import 'package:flutter/material.dart';
import 'package:fisheri/house_texts.dart';
import 'package:recase/recase.dart';

class AmenitiesSection extends StatelessWidget {
  AmenitiesSection(this.amenities);

  final List<dynamic> amenities;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          HouseTexts.heading('Amenities'),
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
      children: [
        Image.asset(
            'images/icons/amenities/$amenity.png',
            height: 20,
            width: 20,
            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              print("couldn't load asset for $amenity");
              return Text('😢');
            }
        ),
        SizedBox(width: 8),
        HouseTexts.body(ReCase(amenity).titleCase)
      ],
    );
  }
}
