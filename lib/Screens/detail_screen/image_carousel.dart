import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  ImageCarousel({
    this.imageURL,
    this.index,
  });

  final String imageURL;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'HeroImage_$index',
        child: Image.asset(
          imageURL,
          width: 600,
          height: 240,
          fit: BoxFit.cover,
        ));
  }
}
