import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(this.descriptionExpanded, this.color);

  final bool descriptionExpanded;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.asset(
          'images/lake.jpg',
          width: 600,
          height: 240,
          fit: BoxFit.cover,
        ),
        _TitleSection(),
        _TextSection(descriptionExpanded),
        _ButtonSection(color),
        const Padding(padding: EdgeInsets.only(bottom: 16)),
        _OverviewSection(),
        _AmenetiesSection(descriptionExpanded),
      ],
    );
  }
}

class _TextSection extends StatelessWidget {
  _TextSection(this.descriptionExpanded);

  final bool descriptionExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: <Widget>[
            Text(
              'Description',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            Text(
              'Manor Farm Lakes is an extensive 100 acre fishery based in the heart of Central Bedfordshire, with easy access from the A1. Manor Farm Lakes consists of a range of 7 different fishing lakes with an 18 van touring caravan site with electric hook-ups. A range of fishing experiences are catered for at Manor Farm Lakes including carp fishing for pleasure anglers and specialists, night fishing, fly fishing for carp, match and coarse angling as well as predator spinning, lure and deadbait fishing in the winter months. The River Ivel acts as the boundary along our eastern edge and is also available to fish with a good head of chub, barbel, pike and bream.',
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: descriptionExpanded ? 8 : 4,
            ),
            FlatButton(
              onPressed: () {
                print(descriptionExpanded);
                // descriptionExpanded = !descriptionExpanded;
              },
              child: Text("Read More", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ));
  }
}

class _TitleSection extends StatelessWidget {
  _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Manor Farm Lakes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                Text('Biggleswade, Hertfordshire',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                    ))
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
        ],
      ),
    );
  }
}

class _ButtonSection extends StatelessWidget {
  _ButtonSection(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    Column _buildButtonColumn(Color color, IconData icon, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButtonColumn(color, Icons.call, 'Call'),
          _buildButtonColumn(color, Icons.language, 'Website'),
          _buildButtonColumn(color, Icons.email, 'Email'),
        ],
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  _OverviewSection();

  @override
  Widget build(BuildContext context) {
    Widget overviewBox = SizedBox(
      width: 50,
      height: 50,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.green),
      ),
    );

    Widget overviewRow = Row(
      children: <Widget>[overviewBox, overviewBox, overviewBox, overviewBox],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget overviewGrid = Column(
      children: <Widget>[
        overviewRow,
        const Padding(padding: EdgeInsets.only(bottom: 32.0)),
        overviewRow
      ],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
      child: Column(
        children: <Widget>[
          Text(
            'Overview',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 16.0)),
          overviewGrid
        ],
      ),
    );
  }
}

class _AmenetiesSection extends StatelessWidget {
  _AmenetiesSection(this.descriptionExpanded);

  final bool descriptionExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
    child: Column(
      children: <Widget>[
        Text(
          'Ameneties',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 16)),
        Text(
          'Manor Farm Lakes is an extensive 100 acre fishery based in the heart of Central Bedfordshire, with easy access from the A1. Manor Farm Lakes consists of a range of 7 different fishing lakes with an 18 van touring caravan site with electric hook-ups. A range of fishing experiences are catered for at Manor Farm Lakes including carp fishing for pleasure anglers and specialists, night fishing, fly fishing for carp, match and coarse angling as well as predator spinning, lure and deadbait fishing in the winter months. The River Ivel acts as the boundary along our eastern edge and is also available to fish with a good head of chub, barbel, pike and bream.',
          softWrap: true,
          overflow: TextOverflow.fade,
          maxLines: descriptionExpanded ? 8 : 4,
        ),
        FlatButton(
          onPressed: () {
            print(descriptionExpanded);
            // _descriptionExpanded = !_descriptionExpanded;
          },
          child: Text("Read More", style: TextStyle(color: Colors.blue)),
        ),
      ],
    ));;
  }
}
