import 'package:fisheri/house_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        padding: const EdgeInsets.all(16),
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
        style: GoogleFonts.raleway(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          color: HouseColors.midnightBlue,
        ));
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
    if (town != null && county != null) {
      return Text('$town, $county',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color: HouseColors.asbestos,
          ));
    }
    return Container();
  }
}
