import 'package:flutter/material.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'grid_item.dart';
import 'header.dart';

class FishingTypesSection extends StatelessWidget {
  FishingTypesSection(this.fishTypes);

  final List<dynamic> fishTypes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        children: [
          Header('Fishing Types'),
          const SizedBox(height: 16),
          Wrap(
              spacing: 16,
              runSpacing: 16,
              children: fishTypes
                  .map((types) => _FishingTypeGridItem(types))
                  .toList())
        ],
      ),
    );
  }
}

class _FishingTypeGridItem extends StatelessWidget {
  _FishingTypeGridItem(this.type);

  final String type;

  @override
  Widget build(BuildContext context) {
    final storageURL = 'gs://fishing-finder-594f0.appspot.com/fishing/types/';
    final actualURL = "$storageURL$type.jpg";

    return GridItem(
      item: type,
      image: Image(image: FirebaseStorageImage(actualURL)),
      width: 120,
    );
  }
}
