import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class AmenitiesSection extends StatelessWidget {
  AmenitiesSection(this.amenities);

  final List<dynamic> amenities;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DSComponents.header(text:'Amenities'),
          DSComponents.paragraphSpacer(),
          Wrap(
              spacing: 8,
              runSpacing: 16,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DSComponents.body(text: ReCase(amenity).titleCase),
        Image.asset(
            'images/icons/amenities/$amenity.png',
            height: 20,
            width: 20,
            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              print("couldn't load asset for $amenity");
              return Text('😢');
            }
        ),
      ],
    );
  }
}
