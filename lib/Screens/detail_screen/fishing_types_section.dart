import 'package:fisheri/Components/pill.dart';
import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
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
      child: Column(
        children: [
          DSComponents.header(text: widget.title),
          DSComponents.doubleSpacer(),
          DSComponents.body(text:
              'We may stock fishing tackle for types of fishing unavailable at this venue.'),
          DSComponents.paragraphSpacer(),
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
          DSComponents.text(
              text: ReCase(item.name).titleCase, alignment: Alignment.center, fontSize: 14),
          DSComponents.singleSpacer(),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: DSColors.black.withOpacity(0.1))),
            padding: EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ColorFiltered(
                child: image,
                colorFilter: ColorFilter.mode(
                    DSColors.green,
                    BlendMode.modulate,
                )
              ),
            ),
          ),
          DSComponents.singleSpacer(),
          if (item.hasFishing)
          Column(
            children: [
              SizedBox(
                width: 65,
                child: Pill(
                  title: 'Fishing',
                  titleColor: DSColors.blue,
                  color: DSColors.pastelBlue,
                ),
              ),
              DSComponents.singleSpacer(),
            ],
          ),
          if (item.hasTackles)
          SizedBox(
            width: 65,
            child: Pill(
              title: 'Tackle',
              titleColor: DSColors.green,
              color: DSColors.pastelGreen,
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
    return GridItem(
      item: widget.item,
      image: Image.asset(
        'images/icons/fishing_types/${widget.item.name}.png',
        color: DSColors.green,
      ),
      width: widget.itemWidth,
    );
  }
}
