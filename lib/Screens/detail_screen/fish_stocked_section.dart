import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

class _FishStockedGridItem extends StatefulWidget {
  _FishStockedGridItem(this.fish);

  final String fish;

  @override
  __FishStockedGridItemState createState() => __FishStockedGridItemState();
}

class __FishStockedGridItemState extends State<_FishStockedGridItem> {
  @override
  Widget build(BuildContext context) {
    final fishURL = widget.fish.replaceAll(" ", "_").toLowerCase();

    Future<Image> _getImage() async {
      String imageURL = await FirebaseStorage.instance.ref().child('fish').child('stock').child(('$fishURL.png')).getDownloadURL();
      return await Image.network(imageURL);
    }

    return FutureBuilder<Image>(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridItem(
            item: widget.fish,
            image: Image.asset('images/question_mark.png'),
            width: 65,
          );
        } else {
          if (snapshot.hasError) {
            return GridItem(
              item: widget.fish,
              image: Image.asset('images/question_mark.png'),
              width: 65,
            );
          } else {
            return GridItem(
              item: widget.fish,
              image: snapshot.data,
              width: 65,
            );
          }
        }
      },
    );
  }
}