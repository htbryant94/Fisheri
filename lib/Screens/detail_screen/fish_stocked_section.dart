import 'package:firebase_storage/firebase_storage.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../venue_form_screen.dart';
import 'grid_item.dart';
import 'package:recase/recase.dart';

class FishStockSectionFactory {
  static FishStockSection standard(List<FishStock> fishStock) {
    return FishStockSection(fishStock);
  }

  static FishStockSection fromStringArray(List<String> array) {
    final List<FishStock> fishStock = array.map((e) => FishStock(name: ReCase(e).titleCase)).toList();
    return FishStockSection(fishStock);
  }
}

class FishStockSection extends StatelessWidget {
  FishStockSection(this.fishStock);

  final List<FishStock> fishStock;

  List<FishStock> fishStockSortedByPriority(List<FishStock> fishStock) {
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
    ];

    fishStock.forEach((stock) {
      stock.priority = fishStockOrder.indexWhere((fishStockList) => ReCase(describeEnum(fishStockList)).titleCase == stock.name);
    });

    fishStock.sort((a, b) => a.priority.compareTo(b.priority));
    return fishStock;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DSComponents.header(text: 'Fish Stocked'),
          DSComponents.paragraphSpacer(),
          Wrap(
              spacing: 16,
              runSpacing: 16,
              children: fishStockSortedByPriority(fishStock)
                  .map((fish) => _FishStockGridItem(
                fishStock: fish,
                itemWidth: MediaQuery.of(context).size.width / 2.5,
              ))
                  .toList())
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
              subtitle: widget.fishStock.weight != null ? 'Max: ${WeightConverter.gramsToPoundsAndOunces(widget.fishStock.weight.toDouble())}' : null,
              image: snapshot.data,
              width: widget.itemWidth,
            );
          }
        }
      },
    );
  }
}
