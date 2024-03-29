// @dart=2.9

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fisheri/Components/favourite_button.dart';
import 'package:fisheri/Components/pill.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/house_texts.dart';
import 'package:flutter/cupertino.dart';
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
    var stuff = <Widget>[
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
    var stuff = <Widget>[
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
    var stuff = <Widget>[
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
    this.imageURL,
    this.image,
    @required this.title,
    this.subtitle,
    @required this.height,
    this.elements,
    this.layout = BaseCellLayout.thumbnail,
    this.imageBoxFit = BoxFit.fitHeight,
    this.showImage = true,
    this.isSponsored = false,
    this.showFavouriteButton = false,
    this.imagePadding = 0,
  });

  final String defaultImagePath;
  final String imageURL;
  final Image image;
  final String title;
  final String subtitle;
  final double height;
  final List<Widget> elements;
  final BaseCellLayout layout;
  final BoxFit imageBoxFit;
  final bool showImage;
  final bool isSponsored;
  final bool showFavouriteButton;
  final double imagePadding;

  List<Widget> _children() {
    var stuff = <Widget>[
      layout == BaseCellLayout.cover ? DSComponents.subheader(text: title, maxLines: 1) : DSComponents.subheaderSmall(text: title, maxLines: 1),
      if (subtitle != null)
        layout == BaseCellLayout.cover ? DSComponents.body(text: subtitle) : DSComponents.bodySmall(text: subtitle)
    ];
    if (elements != null && elements.isNotEmpty) {
      stuff += elements;
    }
    return stuff;
  }

  Widget _makeImage(String imageURL, Image image) {
    if (imageURL != null) {
      return CachedNetworkImage(
        fit: imageBoxFit,
        imageUrl: imageURL,
        placeholder: (context, url) => Container(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
        ),
      );
    } else if (image != null) {
      return image;
    } else {
      return Image.asset(defaultImagePath ?? 'images/lake.jpg');
    }
  }

  Widget thumbnailView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (showImage)
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(imagePadding),
                child: _makeImage(imageURL, image)
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _children(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget coverView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              imageURL != null ? Container(
                height: 180,
                width: double.maxFinite,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: !isSponsored ? Border.all(color: DSColors.grey.withOpacity(0.5), width: 0.5) : Border.all(color: DSColors.green, width: 6),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageURL,
                  placeholder: (context, url) => Container(
                      padding: EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                  ),
                ),
              ) : Container(
                  height: 180,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(defaultImagePath ?? 'images/lake.jpg', fit: BoxFit.cover)
              ),
              if (showFavouriteButton)
              Positioned(
                right: 16,
                bottom: 16,
                child: FavouriteButton(),
              ),
              if (isSponsored)
                Positioned(
                    top: 12,
                    left: 12,
                    child: Pill(
                      color: DSColors.pastelGreen,
                      title: 'Sponsored',
                      titleColor: DSColors.green,
                      icon: Icon(Icons.star_outline_outlined, color: DSColors.green, size: 18),
                    )
                )
            ],
          ),
          DSComponents.doubleSpacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _children(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: layout == BaseCellLayout.thumbnail ? height / 2 : height,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: layout == BaseCellLayout.thumbnail ? thumbnailView() : coverView()
    );
  }
}
