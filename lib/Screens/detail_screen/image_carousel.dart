import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  ImageCarousel(this.imageURL);

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'HeroImage',
        child: Image.asset(
          imageURL,
          width: 600,
          height: 240,
          fit: BoxFit.cover,
        ));
  }
}
