import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DSColors {
  static const Color pastelBlue = Color(0xffE5F1FF);
  static const Color pastelGreen = Color(0xffEAF6EF);
  static const Color pastelOrange = Color(0xffFFF1E4);

  static const Color black = Color(0xff222222);
  static const Color blue = Color(0xff52A0FF);
  static const Color green = Color(0xff34A86E);
  static const Color grey = Color(0xff717171);
  static const Color orange = Color(0xffFFA048);
}

class DesignSystemFonts {
  static TextStyle title = GoogleFonts.dMSans(
    color: DSColors.black,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.2,
    fontSize: 20,
  );

  static TextStyle header = GoogleFonts.dMSans(
    color: DSColors.black,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.2,
    fontSize: 18,
  );

  static TextStyle body = GoogleFonts.dMSans(
    color: DSColors.grey,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    fontSize: 13,
  );
}

class DSComponents {
  
  static SizedBox singleSpacer() {
    return SizedBox(height: 8);
  }
  
  static SizedBox doubleSpacer() {
    return SizedBox(height: 16);
  }
  
  static SizedBox sectionSpacer() {
    return SizedBox(height: 50);
  }
  
  static Widget divider() {
    return Column(
      children: [
        sectionSpacer(),
        Divider(thickness: 0.5, color: DSColors.black.withOpacity(0.2)),
        sectionSpacer(),
      ],
    );
  }

  static Widget title({
    String text,
    AlignmentGeometry alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: DesignSystemFonts.title,
      ),
    );
  }
  
  static Widget header({
    String text,
    AlignmentGeometry alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: DesignSystemFonts.header,
      ),
    );
  }

  static Widget body({
    String text,
    AlignmentGeometry alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: DesignSystemFonts.body,
      ),
    );
  }

  static Widget text({
    String text,
    double fontSize,
    FontWeight fontWeight,
    Color color,
    AlignmentGeometry alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.dMSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
