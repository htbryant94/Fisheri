import 'package:carousel_slider/carousel_slider.dart';
import 'package:fisheri/Components/favourite_button.dart';
import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({
    @required this.imageURLs,
    this.index = 0,
    this.fit = BoxFit.cover,
    this.height,
    this.showFavouriteButton = true,
    this.indexChanged,
    this.controller,
  });

  final List<String> imageURLs;
  final int index;
  final BoxFit fit;
  final bool showFavouriteButton;
  final double height;
  final ValueChanged<int> indexChanged;
  final CarouselController controller;

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
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            initialPage: widget.index,
            height: widget.height,
            onPageChanged: (index, reason) {
                setState(() {
                  _currentPageNotifier.value = index;
                });
                widget.indexChanged(_currentPageNotifier.value);
              },
          ),
          carouselController: widget.controller,
          itemCount: imageURLsHasValue() ? widget.imageURLs.length : 1,
          itemBuilder: (BuildContext context, int index, int realIndex) =>
              imageURLsHasValue()
                  ? CachedNetworkImage(
                    imageUrl: widget.imageURLs[index],
                    fit: widget.fit,
                    placeholder: (context, url) => Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(DSColors.green)),
                    ),
                  )
                  : Image.asset('images/lake.jpg', fit: BoxFit.cover),
        ),
        if (widget.showFavouriteButton)
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
