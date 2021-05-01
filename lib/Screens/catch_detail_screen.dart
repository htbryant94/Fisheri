import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class CatchDetailScreen extends StatelessWidget {
  CatchDetailScreen({
    this.data,
  });

  final Catch data;

  String formattedTemperature(double temp) {
    if (temp != null) {
      return '${temp.toStringAsFixed(1)} °C';
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
    if (data.typeOfFish != null) {
      return '${ReCase(data.catchType).titleCase} Catch - ${ReCase(data.typeOfFish).titleCase}';
    } else {
      return '${ReCase(data.catchType).titleCase} Catch';
    }
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
    return data.catchType == 'match';
  }

  List<String> _carouselImages() {
    if (data.images != null && data.images.isNotEmpty) {
      return data.images;
    } else if (data.images == null && _isMatch()) {
      return [_makeMatchPositionImageURL(data.position)];
    } else {
      return [_makeImageURL(data.typeOfFish)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              ImageCarousel(
                imageURLs: _carouselImages(),
                fit: BoxFit.contain,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    DSComponents.paragraphSpacer(),
                    TitleSection(
                      title: _makeTitle(),
                    ),
                    DSComponents.paragraphSpacer(),
                    if (data.weight != null)
                      _DetailRow(name: 'Weight', emoji: '⚖️', value: WeightConverter.gramsToPoundsAndOunces(data.weight)),
                    if (data.time != null)
                      _DetailRow(name: 'Time', emoji: '⏱', value: data.time),
                    if (data.date != null)
                      _DetailRow(name: 'Date', emoji: '🗓', value: formattedDate(data.date)),
                    if (data.weatherCondition != null)
                      _DetailRow(name: 'Weather Condition', emoji: '🌤', value: ReCase(data.weatherCondition).titleCase),
                    if (data.windDirection != null)
                      _DetailRow(name: 'Wind Direction', emoji: '🧭', value: ReCase(data.windDirection).titleCase),
                    if (data.temperature != null)
                      _DetailRow(name: 'Temperature', emoji: '🌡', value: formattedTemperature((data.temperature))),
                    if (data.notes != null)
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
                          DSComponents.body(text: data.notes),
                        ],
                      )
                  ],
                ),
              )
            ],
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
        DSComponents.doubleSpacer()
      ],
    );
  }
}
