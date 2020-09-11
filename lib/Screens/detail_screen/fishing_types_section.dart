import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recase/recase.dart';

class FishingTypesSection extends StatefulWidget {
  FishingTypesSection({
    this.title,
    this.fishTypes,
    this.fishTackles,
  });

  final List<dynamic> fishTypes;
  final List<dynamic> fishTackles;
  final String title;

  @override
  _FishingTypesSectionState createState() => _FishingTypesSectionState();
}

class _FishingTypesSectionState extends State<FishingTypesSection> {

  List<String> _combinedTypes;
  List<String> _tackles;
  List<String> _types;

  @override
  void initState() {
    super.initState();

    if (widget.fishTypes != null && widget.fishTackles != null) {
      _tackles = widget.fishTackles.cast<String>();
      _types = widget.fishTypes.cast<String>();
      _combinedTypes = _combineTypesAndTackles(types: _types, tackles: _tackles);
    } else if (widget.fishTypes != null && widget.fishTackles == null) {
      _types = widget.fishTypes.cast<String>();
      _combinedTypes = _types;
    } else if (widget.fishTypes == null && widget.fishTackles != null) {
      _tackles = widget.fishTackles.cast<String>();
      _combinedTypes = _tackles;
    }

  }

  List<String> _combineTypesAndTackles({List<String> types, List<String> tackles}) {
    final List<String> _uniqueTypes = [];
    _uniqueTypes.addAll(types);

    var _filteredTackles = tackles.where((tackle) => !_uniqueTypes.contains(tackle)).toList();
    _uniqueTypes.addAll(_filteredTackles);

    return _uniqueTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          DesignSystemComponents.header(text: widget.title),
          SizedBox(height: 16),
          DesignSystemComponents.body(text:
              "We stock for associated fishing tackles. In some cases we stock tackles for fishing types that aren't available at this location."),
          SizedBox(height: 32),
          Wrap(
              spacing: 16,
              runSpacing: 32,
              children: _combinedTypes.map((uniqueType) =>
                  _FishingTypeGridItem(
                    itemWidth: (MediaQuery.of(context).size.width / 4),
                    item: _FishingTypeTackleItem(
                      name: uniqueType,
                      hasFishing: _types != null ? _types.contains(uniqueType) : false,
                      hasTackles: _tackles != null ? _tackles.contains(uniqueType) : false,
                    ),
                  )).toList())
        ],
      ),
    );
  }
}

class _FishingTypeTackleItem {
  _FishingTypeTackleItem({
    this.name,
    this.hasFishing,
    this.hasTackles
  });

  final String name;
  final bool hasFishing;
  final bool hasTackles;
}

class GridItem extends StatelessWidget {
  GridItem({this.item, this.image, this.width});

  final _FishingTypeTackleItem item;
  final Image image;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          DesignSystemComponents.text(
              text: ReCase(item.name).titleCase, alignment: Alignment.center, fontSize: 14),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: DesignSystemColors.black.withOpacity(0.1))),
            padding: EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: image,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: item.hasFishing ? DesignSystemColors.pastelBlue : Colors.grey[100],
              borderRadius: BorderRadius.circular(width),
            ),
            width: 65,
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: DesignSystemComponents.text(
                text: "Fishing",
                alignment: Alignment.center,
                fontSize: 12,
                color: item.hasFishing ? DesignSystemColors.blue : DesignSystemColors.blue.withOpacity(0.5)
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: item.hasTackles ? DesignSystemColors.pastelGreen : Colors.grey[100],
              borderRadius: BorderRadius.circular(width),
            ),
            width: 65,
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: DesignSystemComponents.text(
                text: "Tackles",
                alignment: Alignment.center,
                fontSize: 12,
                color: item.hasTackles ? DesignSystemColors.green : DesignSystemColors.green.withOpacity(0.5)
            ),
          ),
        ],
      ),
    );
  }
}

class _FishingTypeGridItem extends StatefulWidget {
  _FishingTypeGridItem({
    this.item,
    this.itemWidth,
  });

  final _FishingTypeTackleItem item;
  final double itemWidth;

  @override
  __FishingTypeGridItemState createState() => __FishingTypeGridItemState();
}

class __FishingTypeGridItemState extends State<_FishingTypeGridItem> {
  @override
  Widget build(BuildContext context) {
    Future<Image> _getImage() async {
      String imageURL = await FirebaseStorage.instance
          .ref()
          .child('fishing')
          .child('types')
          .child(('${widget.item.name}.png'))
          .getDownloadURL();
      return await Image.network(imageURL);
    }

    return FutureBuilder<Image>(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridItem(
            item: widget.item,
            image: Image.asset('images/question_mark.png'),
            width: widget.itemWidth,
          );
        } else {
          if (snapshot.hasError) {
            return GridItem(
              item: widget.item,
              image: Image.asset('images/question_mark.png'),
              width: widget.itemWidth,
            );
          } else {
            return GridItem(
              item: widget.item,
              image: snapshot.data,
              width: widget.itemWidth,
            );
          }
        }
      },
    );
  }
}
