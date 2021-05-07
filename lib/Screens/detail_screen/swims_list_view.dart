import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

import '../../coordinator.dart';
import '../../design_system.dart';

class Swim {
  Swim({
    this.name,
    this.imageURL,
  });

  final String name;
  final String imageURL;
}

class SwimsListView extends StatelessWidget {
  SwimsListView({
    @required this.swims,
  });

  final List<Swim> swims;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: 'Swims'),
        DSComponents.paragraphSpacer(),
        Container(
            height: 200,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0),
                itemCount: swims.length,
                separatorBuilder: (BuildContext context, int index) {
                  return DSComponents.doubleSpacer();
                },
                itemBuilder: (context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.asset(swims[index].imageURL, fit: BoxFit.fill)
                            ),
                          ),
                          onTap: () {
                            Coordinator.present(
                                context,
                                screenTitle: '360° View',
                                screen: Panorama(
                                  child: Image.asset(swims[index].imageURL),
                                )
                            );
                          },
                        ),
                      ),
                      DSComponents.singleSpacer(),
                      DSComponents.subheader(text: swims[index].name)
                    ],
                  );
                })
        )
      ],
    );
  }
}