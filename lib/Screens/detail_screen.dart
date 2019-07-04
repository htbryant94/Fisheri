import 'package:fisheri/house_colors.dart';
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
        _TitleSection(title: title, subtitle: 'Biggleswade, Hertfordshire'),
        _DescriptionSection(descriptionExpanded),
        _ButtonSection(Colors.blue),
        SizedBox(height: 16),
        _FishStocked(),
        _FishingTypes(),
        _AmenitiesSection(),
        _Tickets(),
        _OpeningHours(),
        _FishingRules(true),
        // _OverviewSection(),
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

class _Header extends StatelessWidget {
  _Header(this.header);

  final String header;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(header,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
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

    Text textBody = Text(
      'Manor Farm Lakes is an extensive 100 acre fishery based in the heart of Central Bedfordshire, with easy access from the A1. Manor Farm Lakes consists of a range of 7 different fishing lakes with an 18 van touring caravan site with electric hook-ups. A range of fishing experiences are catered for at Manor Farm Lakes including carp fishing for pleasure anglers and specialists, night fishing, fly fishing for carp, match and coarse angling as well as predator spinning, lure and deadbait fishing in the winter months. The River Ivel acts as the boundary along our eastern edge and is also available to fish with a good head of chub, barbel, pike and bream.',
      softWrap: true,
      overflow: TextOverflow.fade,
      maxLines: descriptionExpanded ? 8 : 4,
    );

    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: [
          _Header('Description'),
          SizedBox(height: 16),
          textBody,
          readMoreButton
        ]));
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

// class _OverviewSection extends StatelessWidget {
//   _OverviewSection();

//   @override
//   Widget build(BuildContext context) {
//     Widget overviewBox = SizedBox(
//       width: 50,
//       height: 50,
//       child: DecoratedBox(decoration: const BoxDecoration(color: Colors.green)),
//     );

//     Widget overviewRow = Row(
//       children: [overviewBox, overviewBox, overviewBox, overviewBox],
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     );

//     Widget overviewGrid = Column(
//       children: [overviewRow, SizedBox(height: 32), overviewRow],
//     );

//     return Container(
//       padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
//       child: Column(
//         children: [
//           Text(
//             'Overview',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           overviewGrid
//         ],
//       ),
//     );
//   }
// }

class _FishStocked extends StatelessWidget {
  _FishStocked();

  @override
  Widget build(BuildContext context) {
    Widget overviewBox = SizedBox(
      width: 60,
      height: 60,
      child: DecoratedBox(decoration: const BoxDecoration(color: Colors.green)),
    );

    Widget overviewRow = Row(
      children: [overviewBox, overviewBox, overviewBox, overviewBox],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget overviewGrid = Column(
      children: [overviewRow, SizedBox(height: 16), overviewRow],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        children: [
          _Header('Fish Stocked'),
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
    Widget _box = SizedBox(
      width: 90,
      height: 75,
      child: DecoratedBox(decoration: const BoxDecoration(color: Colors.green)),
    );

    Widget _row = Row(
      children: [_box, _box, _box],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget _grid = Column(
      children: [_row, SizedBox(height: 16), _row],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        children: [
          _Header('Types of Fishing'),
          const SizedBox(height: 16),
          _grid
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
      children: [Icon(Icons.person), Text('Toilets')],
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  _AmenitiesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: <Widget>[
            _Header('Amenities'),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _Amenity(),
                    _Amenity(),
                    _Amenity(),
                  ],
                ),
                Column(
                  children: <Widget>[
                    _Amenity(),
                    _Amenity(),
                    _Amenity(),
                  ],
                )
              ],
            )
          ],
        ));
  }
}

class _Tickets extends StatelessWidget {
  _Tickets();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: <Widget>[
            _Header('Tickets'),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text('Day', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            ),
            Row(
              children: <Widget>[
                Text('Syndicate',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            ),
            Row(
              children: <Widget>[
                Text('Season', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            ),
            Row(
              children: <Widget>[
                Text('Club', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Price from: £39'),
                Spacer(),
                RaisedButton(
                    child: Text(
                      "See more",
                      style: TextStyle(color: HouseColors.primaryGreen),
                    ),
                    color: HouseColors.accentGreen,
                    onPressed: () {})
              ],
            )
          ],
        ));
  }
}

class _OpeningHoursRow extends StatelessWidget {
  _OpeningHoursRow(this.day, this.openTime, this.closeTime);

  final String day;
  final String openTime;
  final String closeTime;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(day),
          Text('$openTime - $closeTime'),
        ]);
  }
}

class _OpeningHours extends StatelessWidget {
  _OpeningHours();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Column(children: <Widget>[
        _Header('Opening Hours'),
        SizedBox(height: 16),
        _OpeningHoursRow('Monday', '09:00', '22:00'),
        _OpeningHoursRow('Tuesday', '09:00', '22:00'),
        _OpeningHoursRow('Wednesday', '09:00', '22:00'),
        _OpeningHoursRow('Thursday', '09:00', '22:00'),
        _OpeningHoursRow('Friday', '09:00', '22:00'),
        _OpeningHoursRow('Saturday', '09:00', '22:00'),
        _OpeningHoursRow('Sunday', '09:00', '22:00'),
      ]),
    );
  }
}

class _FishingRules extends StatelessWidget {
  _FishingRules(this.isExpanded);

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    FlatButton readMoreButton = FlatButton(
        child: Text("Read More", style: TextStyle(color: Colors.blue)),
        onPressed: () {
          print(isExpanded);
          // descriptionExpanded = !descriptionExpanded;
        });

    Text textBody = Text(
      'When and where you can fish National close season rules for coarse fishing apply across the Anglian region. The coarse fishing close season between 15 March and 15 June applies to all rivers, streams, drains, the Norfolk Broads and some stillwaters. Dates are inclusive All dates mentioned in these byelaws are inclusive: this means a stated period, such as 15 March to 15 June, includes the full day of 15 March and the full day of 15 June. Salmon and migratory trout The close season for salmon and migratory trout (in all waters) is 29 September to the last day of February. There is also a weekly close time from 6am on Sunday to midnight on the following day. A small number of rivers in Anglia have been canalised (converted into canals), and remain subject to the national close season: Fossdyke Canal, Louth Canal, Horncastle Canal and the Dilham and North Walsham Canal.',
      softWrap: true,
      overflow: TextOverflow.fade,
      maxLines: isExpanded ? 8 : 4,
    );

    return Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(children: [
          _Header('Fishing Rules'),
          SizedBox(height: 16),
          textBody,
          readMoreButton
        ]));
  }
}
