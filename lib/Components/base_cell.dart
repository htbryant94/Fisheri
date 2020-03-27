import 'package:cached_network_image/cached_network_image.dart';
import 'package:fisheri/house_texts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fisheri/house_colors.dart';

class LocalImageBaseCell extends StatelessWidget {
  LocalImageBaseCell({
    @required this.image,
    @required this.title,
    @required this.subtitle,
    this.elements,
  });

  final Image image;
  final String title;
  final String subtitle;
  final List<Widget> elements;

  List<Widget> _children() {
    List<Widget> stuff = [HouseTexts.heading('$title'), HouseTexts.subheading('$subtitle')];
    if (elements != null && elements.isNotEmpty) {
      stuff += elements;
    }
    return stuff;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 3,
      child: Container(
        height: 120,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(0),
                      image:
                          DecorationImage(image: image.image, fit: BoxFit.fill),
                      color: HouseColors.primaryGreen),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _children(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemoteImageBaseCell extends StatelessWidget {
  RemoteImageBaseCell({
    this.defaultImagePath,
    @required this.imageURL,
    @required this.title,
    @required this.subtitle,
    this.elements,
  });

  final String defaultImagePath;
  final String imageURL;
  final String title;
  final String subtitle;
  final List<Widget> elements;

  List<Widget> _children() {
    List<Widget> stuff = [HouseTexts.heading('$title'), HouseTexts.subheading('$subtitle')];
    if (elements != null && elements.isNotEmpty) {
      stuff += elements;
    }
    return stuff;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 3,
      child: Container(
        height: 120,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1.0,
                  child: imageURL != null
                      ? CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: imageURL,
                          placeholder: (context, url) => Container(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Image.asset(defaultImagePath ?? 'images/lake.jpg',
                          fit: BoxFit.fill)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _children(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
