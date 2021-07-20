import 'package:carousel_slider/carousel_controller.dart';
import 'package:fisheri/Screens/detail_screen/fullscreen_image_carousel.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/alert_dialog_factory.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import '../coordinator.dart';
import '../firestore_request_service.dart';

class CatchDetailScreen extends StatefulWidget {
  CatchDetailScreen({
    this.data,
    this.catchID,
  });

  final Catch data;
  final String catchID;

  @override
  _CatchDetailScreenState createState() => _CatchDetailScreenState();
}

class _CatchDetailScreenState extends State<CatchDetailScreen> {
  final _carouselController = CarouselController();
  int _currentImageCarouselIndex = 0;

  String formattedTemperature(double temp) {
    if (temp != null) {
      return '${temp.truncate()} °C';
    }
    return 'No information';
  }

  String formattedDate(String date) {
    return date != null
        ? DateFormat('EEEE, MMM d, yyyy')
        .format(DateTime.parse(date))
        : 'No Date';
  }

  String _makeTitle() {
    if (widget.data.typeOfFish != null) {
      return '${ReCase(widget.data.typeOfFish).titleCase}';
    } else {
      return '${ReCase(widget.data.catchType).titleCase} Catch';
    }
  }

  String _makeSubtitle() {
    if (widget.data.catchType != 'missed' && widget.data.catchType != 'match') {
      return '${ReCase(widget.data.catchType).titleCase} Catch';
    }
    return null;
  }

  String _makeImageURL(String fish) {
    if (fish != null) {
      final sanitisedFish = ReCase(fish).snakeCase;
      return 'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/fish%2Fstock_new%2F$sanitisedFish.png?alt=media&token=b8893ebd-5647-42a2-bfd3-9c2026f2703d';
    }
    return null;
  }

  String _makeMatchPositionImageURL(int position) {
    if (position != null) {
      return 'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/position%2F$position.png?alt=media&token=840bfbfb-a8a6-4295-a7fc-1e0d8a9ed3c6';
    }
    return null;
  }

  bool _isMatch() {
    return widget.data.catchType == 'match';
  }

  List<String> _carouselImages() {
    if (widget.data.images != null && widget.data.images.isNotEmpty) {
      return widget.data.images;
    } else if (widget.data.images == null && _isMatch()) {
      return [_makeMatchPositionImageURL(widget.data.position)];
    } else if (widget.data.images == null && widget.data.typeOfFish != null) {
      return [_makeImageURL(widget.data.typeOfFish)];
    }
  }

  List<Widget> _buildSections() {
    return [
      if (widget.data.catchType != 'missed')
      GestureDetector(
        onTap: () {
          Coordinator.present(
            context,
            showNavigationBar: false,
            screen: FullscreenImageCarousel(
              carouselController: _carouselController,
              images: _carouselImages(),
              initialIndex: _currentImageCarouselIndex,
            )
          );
        },
        child: ImageCarousel(
          imageURLs: _carouselImages(),
          index: _currentImageCarouselIndex,
          controller: _carouselController,
          height: 300,
          showFavouriteButton: false,
          indexChanged: (index) {
            setState(() {
              _currentImageCarouselIndex = index;
            });
          },
          fit: BoxFit.contain,
        ),
      ),
      Column(
        children: [
          DSComponents.paragraphSpacer(),
          TitleSection(
            title: _makeTitle(),
            subtitle: _makeSubtitle(),
          ),
        ],
      ),
      if (widget.data.weight != null)
        _DetailRow(name: 'Weight', emoji: '⚖️', value: WeightConverter.gramsToPoundsAndOunces(widget.data.weight)),
      if (widget.data.time != null)
        _DetailRow(name: 'Time', emoji: '⏱', value: widget.data.time),
      if (widget.data.date != null)
        _DetailRow(name: 'Date', emoji: '🗓', value: formattedDate(widget.data.date)),
      if (widget.data.weatherCondition != null)
        _DetailRow(name: 'Weather Condition', emoji: '🌤', value: ReCase(widget.data.weatherCondition).titleCase),
      if (widget.data.windDirection != null)
        _DetailRow(name: 'Wind Direction', emoji: '🧭', value: ReCase(widget.data.windDirection).titleCase),
      if (widget.data.temperature != null)
        _DetailRow(name: 'Temperature', emoji: '🌡', value: formattedTemperature((widget.data.temperature))),
      if (widget.data.notes != null)
        Column(
          children: [
            Row(
              children: [
                Text('📝', style: TextStyle(fontSize: 20)),
                DSComponents.singleSpacer(),
                DSComponents.subheader(text: 'Notes'),
              ],
            ),
            DSComponents.doubleSpacer(),
            DSComponents.body(text: widget.data.notes),
          ],
        ),
      CupertinoButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.delete_solid, color: Colors.red, size: 20),
            DSComponents.body(
                text: 'Delete',
                color: Colors.red,
                alignment: Alignment.center,
            ),
          ],
        ),
          onPressed: () async {
          var _shouldDelete = false;

          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialogFactory.deleteConfirmation(
                  context: context,
                  onDeletePressed: () {
                    _shouldDelete = true;
                    Navigator.of(context).pop();
                  }
                );
              });

            if (_shouldDelete) {
              if (widget.data.images != null && widget.data.images.isNotEmpty) {
                await FireStorageRequestService.defaultService().deleteImages(
                    widget.data.images);
              }

              await FirestoreRequestService
                  .defaultService()
                  .deleteCatch(widget.catchID)
                  .whenComplete(() {
                Navigator.of(context).pop();
              });
            }
        })
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _rows = _buildSections();

    return Scaffold(
        body: SafeArea(
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: 24),
            itemCount: _rows.length,
            separatorBuilder: (context, index) {
              if (index > 0) {
                return Divider(indent: 64);
              } else {
                return Container();
              }
            },
            itemBuilder: (context, index) {
              if (index > 0 || widget.data.catchType == 'missed') {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: _rows[index],
                );
              } else {
                return _rows[index];
              }
            },
          ),
        ));
  }
}

class _DetailRow extends StatelessWidget {
  _DetailRow({
    this.name,
    this.emoji,
    this.value,
});

  final String name;
  final String emoji;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (emoji != null)
            Row(
              children: [
                Text(emoji, style: TextStyle(fontSize: 20)),
                DSComponents.singleSpacer(),
                DSComponents.subheader(text: name),
              ],
            ),
            if (emoji == null)
              DSComponents.subheader(text: name),
            DSComponents.body(text: '$value')
          ],
        ),
      ],
    );
  }
}
