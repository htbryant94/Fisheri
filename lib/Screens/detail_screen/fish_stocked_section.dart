import 'package:flutter/material.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'header.dart';
import 'grid_item.dart';

class FishStockedSection extends StatelessWidget {
  FishStockedSection(this.fishStock);

  final List<dynamic> fishStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        children: [
          Header('Fish Stocked'),
          const SizedBox(height: 16),
          Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
              fishStock.map((fish) => _FishStockedGridItem(fish)).toList())
        ],
      ),
    );
  }
}

class _FishStockedGridItem extends StatelessWidget {
  _FishStockedGridItem(this.fish);

  final String fish;

  @override
  Widget build(BuildContext context) {
    final storageURL = 'gs://fishing-finder-594f0.appspot.com/fish/stock/';
    final fishURL = fish.replaceAll(" ", "_").toLowerCase();
    final actualURL = "$storageURL$fishURL.png";

    return GridItem(
      item: fish,
      image: Image(image: FirebaseStorageImage(actualURL)),
      width: 65,
    );
  }
}