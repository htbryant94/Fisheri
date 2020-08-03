import 'package:cached_network_image/cached_network_image.dart';
import 'package:fisheri/house_texts.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/house_colors.dart';
import 'package:flutter/rendering.dart';

class LocalImageCoverCell extends StatelessWidget {
  LocalImageCoverCell({
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
    List<Widget> stuff = [
      HouseTexts.heading('$title'),
      HouseTexts.subheading('$subtitle')
    ];
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
        height: 275,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 3,
              child: Image.asset(
                'images/lake.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _children(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum BaseCellLayout { cover, thumbnail }

class NewLocalImageBaseCell extends StatelessWidget {
  NewLocalImageBaseCell({
    @required this.image,
    @required this.title,
    @required this.subtitle,
    @required this.height,
    this.elements,
    this.layout = BaseCellLayout.cover,
  });

  final Image image;
  final String title;
  final String subtitle;
  final double height;
  final List<Widget> elements;
  final BaseCellLayout layout;

  List<Widget> _children() {
    List<Widget> stuff = [
      HouseTexts.heading('$title'),
      HouseTexts.subheading('$subtitle')
    ];
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
          height: layout == BaseCellLayout.cover ? height : height / 2,
          child: layout == BaseCellLayout.cover
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.asset(
                        'images/lake.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _children(),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'images/lake.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _children(),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}

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
    List<Widget> stuff = [
      HouseTexts.heading('$title'),
      HouseTexts.subheading('$subtitle')
    ];
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
    @required this.height,
    this.elements,
    this.layout = BaseCellLayout.thumbnail,
  });

  final String defaultImagePath;
  final String imageURL;
  final String title;
  final String subtitle;
  final double height;
  final List<Widget> elements;
  final BaseCellLayout layout;

  List<Widget> _children() {
    List<Widget> stuff = [
      HouseTexts.heading('$title'),
      if (subtitle != null) HouseTexts.subheading('$subtitle')
    ];
    if (elements != null && elements.isNotEmpty) {
      stuff += elements;
    }
    return stuff;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 2,
      child: Container(
        height: layout == BaseCellLayout.thumbnail ? height / 2 : height,
        color: Colors.white,
        child: layout == BaseCellLayout.thumbnail
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(
                        aspectRatio: 1,
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
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 4,
                      child: imageURL != null
                          ? CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: imageURL,
                              placeholder: (context, url) => Container(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Image.asset(defaultImagePath ?? 'images/lake.jpg'),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _children(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
