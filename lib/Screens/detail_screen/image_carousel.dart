import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({
    this.imageURL,
    this.index,
  });

  final String imageURL;
  final int index;

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider.builder(
        viewportFraction: 1.0,
        itemCount: 5,
        height: 350,
        itemBuilder: (BuildContext context, int itemIndex) =>
            widget.imageURL != null
                ? CachedNetworkImage(
                    imageUrl: widget.imageURL,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Image.asset(
                    ('images/lake.jpg'),
                    fit: BoxFit.cover,
                  ),
        onPageChanged: (index) {
          setState(() {
            _currentPageNotifier.value = index;
          });
        },
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 16,
        child: CirclePageIndicator(
          selectedDotColor: Colors.white,
          dotColor: Colors.grey[400],
          itemCount: 5,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    ]);
  }
}
