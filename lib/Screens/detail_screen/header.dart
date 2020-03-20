import 'package:fisheri/house_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  Header(this.header);

  final String header;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(header,
            style: GoogleFonts.raleway(
              fontSize: 18,
              color: HouseColors.wetAsphalt,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
              fontStyle: FontStyle.normal,
            )));
  }
}
