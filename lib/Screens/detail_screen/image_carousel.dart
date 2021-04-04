import 'package:carousel_slider/carousel_slider.dart';
import 'package:fisheri/Components/favourite_button.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/firestore_request_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({
    @required this.imageURLs,
    this.index,
  });

  final List<String> imageURLs;
  final int index;

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  bool imageURLsHasValue() {
    return widget.imageURLs != null && widget.imageURLs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          viewportFraction: 1.0,
          enableInfiniteScroll: false,
          itemCount: imageURLsHasValue() ? widget.imageURLs.length : 1,
          height: 268,
          itemBuilder: (BuildContext context, int itemIndex) =>
              imageURLsHasValue()
                  ? Container(
                      child: CachedNetworkImage(
                        imageUrl: widget.imageURLs[itemIndex],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(DSColors.green)),
                        ),
                      ),
                    )
                  : Image.asset('images/lake.jpg', fit: BoxFit.cover),
          onPageChanged: (index) {
            setState(() {
              _currentPageNotifier.value = index;
            });
          },
        ),
        Positioned(
          bottom: 16,
          right: 24,
          child: FavouriteButton(),
        ),
        if (imageURLsHasValue())
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: CirclePageIndicator(
              selectedDotColor: Colors.white,
              dotColor: Colors.grey[500],
              itemCount: imageURLsHasValue() ? widget.imageURLs.length : 1,
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
      ],
    );
  }
}
