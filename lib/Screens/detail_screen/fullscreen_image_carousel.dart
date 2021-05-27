
import 'package:carousel_slider/carousel_controller.dart';
import 'package:fisheri/Components/fisheri_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'image_carousel.dart';

class FullscreenImageCarousel extends StatefulWidget {
  FullscreenImageCarousel({
    this.images,
    this.carouselController,
    this.initialIndex,
});

  final List<String> images;
  final CarouselController carouselController;
  final initialIndex;

  @override
  _FullscreenImageCarouselState createState() => _FullscreenImageCarouselState();
}

class _FullscreenImageCarouselState extends State<FullscreenImageCarousel> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ImageCarousel(
              imageURLs: widget.images,
              fit: BoxFit.fitWidth,
              height: double.infinity,
              index: _currentIndex,
              showFavouriteButton: false,
              indexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            Positioned(
                top: 24,
                left: 16,
                child: Container(
                  height: 44,
                  width: 44,
                  child: FisheriIconButton(
                      icon: Icon(Icons.close_fullscreen, color: Colors.white),
                      onTap: () {
                        widget.carouselController.jumpToPage(_currentIndex);
                        Navigator.of(context).pop();
                      }
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
