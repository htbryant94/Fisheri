import 'package:fisheri/house_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HouseTexts {
  
  static Widget title(String text,
      {AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(text,
          style: GoogleFonts.openSans(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          )),
    );
  }

  static Widget subtitle(String text,
      {AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(text,
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color: Colors.black54,
          )),
    );
  }

  static Widget heading(String text,
      {AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  static Widget subheading(String text,
      {AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
      ),
    );
  }

  static Widget body(String text,
      {AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  static Widget custom(
      {String text,
      double fontSize,
      FontWeight fontWeight,
      Color color,
      AlignmentGeometry alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
