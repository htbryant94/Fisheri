import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(this.descriptionExpanded, this.title);

  final bool descriptionExpanded;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _ImageCarousel('images/lake.jpg'),
        _TitleSection(
          title: title,
          subtitle: 'Biggleswade, Hertfordshire'),
        _DescriptionSection(descriptionExpanded),
        _ButtonSection(Colors.blue),
        SizedBox(height: 16),
        // _OverviewSection(),
        _FishTypes(),
        _FishingTypes(),
        _AmenitiesSection(descriptionExpanded),
      ],
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  _ImageCarousel(this.imageURL);

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageURL,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}

class _TitleSection extends StatelessWidget {
  _TitleSection({Key key, this.title, this.subtitle}) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleHeader(title),
                SizedBox(height: 8),
                _TitleSubHeader(subtitle)
              ],
            ),
          ),
          _Favourites(50)
        ],
      ),
    );
  }
}

class _TitleHeader extends StatelessWidget {
  _TitleHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22));
  }
}

class _TitleSubHeader extends StatelessWidget {
  _TitleSubHeader(this.subtitle);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Text(subtitle,
        style: TextStyle(color: Colors.grey[500], fontSize: 18));
  }
}

class _Favourites extends StatelessWidget {
  _Favourites(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.red[500]),
        Text('41'),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  _DescriptionSection(this.descriptionExpanded);

  final bool descriptionExpanded;

  @override
  Widget build(BuildContext context) {
    FlatButton readMoreButton = FlatButton(
        child: Text("Read More", style: TextStyle(color: Colors.blue)),
        onPressed: () {
          print(descriptionExpanded);
          // descriptionExpanded = !descriptionExpanded;
        });

    Text header = Text(
      'Description',
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );

    Text textBody = Text(
      'Manor Farm Lakes is an extensive 100 acre fishery based in the heart of Central Bedfordshire, with easy access from the A1. Manor Farm Lakes consists of a range of 7 different fishing lakes with an 18 van touring caravan site with electric hook-ups. A range of fishing experiences are catered for at Manor Farm Lakes including carp fishing for pleasure anglers and specialists, night fishing, fly fishing for carp, match and coarse angling as well as predator spinning, lure and deadbait fishing in the winter months. The River Ivel acts as the boundary along our eastern edge and is also available to fish with a good head of chub, barbel, pike and bream.',
      softWrap: true,
      overflow: TextOverflow.fade,
      maxLines: descriptionExpanded ? 8 : 4,
    );

    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: [header, SizedBox(height: 16), textBody, readMoreButton],
        ));
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
        children: [
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
        children: [
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
      child: DecoratedBox(decoration: const BoxDecoration(color: Colors.green)),
    );

    Widget overviewRow = Row(
      children: [overviewBox, overviewBox, overviewBox, overviewBox],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget overviewGrid = Column(
      children: [overviewRow, SizedBox(height: 32), overviewRow],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
      child: Column(
        children: [
          Text(
            'Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          overviewGrid
        ],
      ),
    );
  }
}

class _FishingTypes extends StatelessWidget {
  _FishingTypes();

  @override
  Widget build(BuildContext context) {
    Widget overviewBox = SizedBox(
      width: 75,
      height: 75,
      child: DecoratedBox(decoration: const BoxDecoration(color: Colors.green)),
    );

    Widget overviewRow = Row(
      children: [overviewBox, overviewBox, overviewBox],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget overviewGrid = Column(
      children: [overviewRow, SizedBox(height: 16), overviewRow],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
      child: Column(
        children: [
          Text(
            'Types of Fishing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          overviewGrid
        ],
      ),
    );
  }
}

class _FishTypes extends StatelessWidget {
  _FishTypes();

  @override
  Widget build(BuildContext context) {
    Widget overviewBox = SizedBox(
      width: 50,
      height: 50,
      child: DecoratedBox(decoration: const BoxDecoration(color: Colors.green)),
    );

    Widget overviewRow = Row(
      children: [overviewBox, overviewBox, overviewBox, overviewBox],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget overviewGrid = Column(
      children: [overviewRow, SizedBox(height: 32), overviewRow],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
      child: Column(
        children: [
          Text(
            'Fish Stocked',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          overviewGrid
        ],
      ),
    );
  }
}

class _Amenity extends StatelessWidget {
  _Amenity();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person),
        Text('Toilets')
      ],
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  _AmenitiesSection(this.descriptionExpanded);

  final bool descriptionExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: 
        Column(children: <Widget>[
          Text(
            'Amenities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 16)),
          Row(
          children: <Widget>[
            Column(
              children: <Widget>[ 
                _Amenity(),
                _Amenity(),
                _Amenity(),
              ],
            ),
            Column(children: <Widget>[
              _Amenity(),
              _Amenity(),
              _Amenity(),
            ],)
          ],
        )
        ],
        )
        );
  }
}

