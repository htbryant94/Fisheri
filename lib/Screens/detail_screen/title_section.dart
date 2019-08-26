import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  TitleSection({
    this.title,
    this.town,
    this.county,
  });

  final String title;
  final String town;
  final String county;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleHeader(title),
            SizedBox(height: 8),
            _TitleSubHeader(
              town: town,
              county: county,
            ),
          ],
        ));
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
  _TitleSubHeader({
    this.town,
    this.county,
  });

  final String town;
  final String county;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$town, $county',
      style: TextStyle(
        color: Colors.grey[500],
        fontSize: 18,
      ),
    );
  }
}
