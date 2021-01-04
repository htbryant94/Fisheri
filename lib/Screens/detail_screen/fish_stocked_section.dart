import 'package:firebase_storage/firebase_storage.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../venue_form_screen.dart';
import 'grid_item.dart';
import 'package:recase/recase.dart';

class FishStockSectionFactory {
  static FishStockSection standard(List<FishStock> fishStock) {
    return FishStockSection(fishStock: fishStock);
  }

  static FishStockSection fromStringArray(List<String> array) {
    final List<FishStock> fishStock = array.map((e) => FishStock(name: ReCase(e).titleCase)).toList();
    return FishStockSection(fishStock: fishStock);
  }
}

class FishStockSection extends StatelessWidget {
  FishStockSection({
    this.fishStock,
    this.limit = 6,
    this.showHeader = true,
  });

  final List<FishStock> fishStock;
  final int limit;
  final bool showHeader;

  List<FishStock> _fishStockSortedByPriority(List<FishStock> fishStock) {
    List<FishStockList> fishStockOrder = [
      FishStockList.commonCarp,
      FishStockList.mirrorCarp,
      FishStockList.koiCarp,
      FishStockList.pike,
      FishStockList.grassCarp,
      FishStockList.barbel,
      FishStockList.crucianCarp,
      FishStockList.tench,
      FishStockList.chub,
      FishStockList.bream,
      FishStockList.roach,
      FishStockList.perch,
      FishStockList.rudd,
      FishStockList.rainbowTrout,
      FishStockList.brownTrout,
      FishStockList.salmon,
      FishStockList.grayling,
      FishStockList.zander,
      FishStockList.eel,
      FishStockList.orfe,
      FishStockList.dace,
      FishStockList.gudgeon,
      FishStockList.ruffe,
      FishStockList.ide,
    ];

    fishStock.forEach((stock) {
      stock.priority = fishStockOrder.indexWhere((fishStockList) => ReCase(describeEnum(fishStockList)).titleCase == stock.name);
    });

    fishStock.sort((a, b) => a.priority.compareTo(b.priority));
    return fishStock;
  }

  int _getLimit() {
    return fishStock.length < limit ? fishStock.length : limit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (showHeader)
          DSComponents.header(text: 'Fish Stocked'),
          DSComponents.paragraphSpacer(),
          Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _fishStockSortedByPriority(fishStock)
                  .sublist(0, _getLimit())
                  .map((fish) => _FishStockGridItem(
                fishStock: fish,
                itemWidth: MediaQuery.of(context).size.width / 2.5,
              ),
              ).toList()
          ),
          if (fishStock.length > limit)
            Column(
              children: [
                DSComponents.doubleSpacer(),
                CupertinoButton(
                  child: DSComponents.body(text: 'More', color: DSColors.blue),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => CupertinoPageScaffold(
                          navigationBar: CupertinoNavigationBar(
                            middle: Text('Fish Stocked'),
                          ),
                          backgroundColor: Colors.white,
                          child: SafeArea(
                            child: Scaffold(
                              body: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  controller: ModalScrollController.of(context),
                                  child: FishStockSection(fishStock: fishStock, limit: fishStock.length, showHeader: false)),
                            ),
                          ),
                        )
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FishStockGridItem extends StatefulWidget {
  _FishStockGridItem({
    this.fishStock,
    this.itemWidth,
  });

  final FishStock fishStock;
  final double itemWidth;

  @override
  __FishStockGridItemState createState() => __FishStockGridItemState();
}

class __FishStockGridItemState extends State<_FishStockGridItem> {
  @override
  Widget build(BuildContext context) {
    Future<Image> _getImage() async {
      final String assetName = ReCase(widget.fishStock.name).snakeCase;
      String imageURL = await FirebaseStorage.instance
          .ref()
          .child('fish')
          .child('stock_new')
          .child(('$assetName.png'))
          .getDownloadURL();
      return await Image.network(imageURL);
    }

    return FutureBuilder<Image>(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridItem(
            title: widget.fishStock.name,
            image: Image.asset('images/question_mark.png'),
            width: widget.itemWidth,
          );
        } else {
          if (snapshot.hasError) {
            return GridItem(
              title: widget.fishStock.name,
              image: Image.asset('images/question_mark.png'),
              width: widget.itemWidth,
            );
          } else {
            return GridItem(
              title: widget.fishStock.name,
              subtitle: widget.fishStock.weight != null ? 'to: ${WeightConverter.gramsToPoundsWhole(widget.fishStock.weight.toDouble())}' : null,
              image: snapshot.data,
              width: widget.itemWidth,
            );
          }
        }
      },
    );
  }
}
