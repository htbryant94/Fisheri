import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';

class ContentsSection extends StatelessWidget {
  ContentsSection({this.contents});

  final List<String> contents;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: contents
          .map(
            (item) => Column(
              children: [
                Row(
                  children: [
                    DSComponents.body(text: "•", color: DSColors.black),
                    DSComponents.singleSpacer(),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: DSColors.black, // Text colour here
                          width: 0.65, // Underline width
                        ),
                      )),
                      child:
                          DSComponents.body(text: item, color: DSColors.black),
                    )
                  ],
                ),
                DSComponents.doubleSpacer(),
              ],
            ),
          )
          .toList(),
    );
  }
}
