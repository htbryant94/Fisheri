import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../design_system.dart';

class FilterDistancePill extends StatelessWidget {
  FilterDistancePill({
    @required this.distance,
    this.showShadow = false,
    this.showPlus = false,
  });

  final int distance;
  final bool showShadow;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.white,
        border: Border.all(color: DSColors.grey.withOpacity(0.2), width: 0.5),
        boxShadow: showShadow ? [
          BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 4,
              offset: Offset(1,2)
          )
        ] : null,
      ),
      child: Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
                children: [
                  if (showPlus)
                    TextSpan(
                      text: '+',
                      style: GoogleFonts.dMSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: DSColors.black
                      ),
                    ),
                  TextSpan(
                    text: '$distance',
                    style: GoogleFonts.dMSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: DSColors.black
                    ),
                  ),
                  TextSpan(
                    text: 'km',
                    style: GoogleFonts.dMSans(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: DSColors.black
                    ),
                  )
                ]
            ),
          )
      ),
    );
  }
}