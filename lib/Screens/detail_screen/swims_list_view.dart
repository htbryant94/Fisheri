import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

import '../../coordinator.dart';
import '../../design_system.dart';

class PanoramaItem {
  PanoramaItem({
    this.name,
    this.imageURL,
  });
  
  final String name;
  final String imageURL;
}

class PanoramaRail extends StatelessWidget {
  PanoramaRail({
    this.title,
    @required this.items,
  });

  final String title;
  final List<PanoramaItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
        Column(
          children: [
            DSComponents.header(text: title),
            DSComponents.paragraphSpacer(),
          ],
        ),
        Container(
            height: 200,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0),
                itemCount: items.length,
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
                                child: Image.asset(items[index].imageURL, fit: BoxFit.fill)
                            ),
                          ),
                          onTap: () {
                            Coordinator.present(
                                context,
                                screenTitle: '360° View',
                                screen: Panorama(
                                  child: Image.asset(items[index].imageURL),
                                )
                            );
                          },
                        ),
                      ),
                      if (items[index].name != null)
                      Column(
                        children: [
                          DSComponents.singleSpacer(),
                          DSComponents.subheader(text: items[index].name)
                        ],
                      )
                    ],
                  );
                })
        )
      ],
    );
  }
}