import 'package:flutter/material.dart';
import 'grid_item.dart';
import 'header.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FishingTypesSection extends StatelessWidget {
  FishingTypesSection(this.fishTypes);

  final List<dynamic> fishTypes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        children: [
          Header('Fishing Types'),
          const SizedBox(height: 16),
          Wrap(
              spacing: 16,
              runSpacing: 16,
              children: fishTypes
                  .map((types) => _FishingTypeGridItem(
                type: types,
                itemWidth: MediaQuery.of(context).size.width / 2.5,
              )).toList())
        ],
      ),
    );
  }
}

class _FishingTypeGridItem extends StatefulWidget {
  _FishingTypeGridItem({
    this.type,
    this.itemWidth,
});

  final String type;
  final double itemWidth;

  @override
  __FishingTypeGridItemState createState() => __FishingTypeGridItemState();
}

class __FishingTypeGridItemState extends State<_FishingTypeGridItem> {
  @override
  Widget build(BuildContext context) {

    Future<Image> _getImage() async {
      String imageURL = await FirebaseStorage.instance.ref().child('fishing').child('types').child(('${widget.type}.jpg')).getDownloadURL();
      return await Image.network(imageURL);
    }

    return FutureBuilder<Image>(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridItem(
            item: widget.type,
            image: Image.asset('images/question_mark.png'),
            width: widget.itemWidth,
          );
        } else {
          if (snapshot.hasError) {
            return GridItem(
              item: widget.type,
              image: Image.asset('images/question_mark.png'),
              width: widget.itemWidth,
            );
          } else {
            return Card(
              elevation: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: GridItem(
                  item: widget.type,
                  image: snapshot.data,
                  width: widget.itemWidth,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
