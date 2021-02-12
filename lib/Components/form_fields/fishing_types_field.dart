import 'package:fisheri/house_texts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:recase/recase.dart';

enum FishingTypes {
  carp,
  catfish,
  coarse,
  fly,
  match,
  predator,
  sea,
}

class FishingTypesField extends StatelessWidget {
  FishingTypesField({
    @required this.title,
    @required this.attribute,
    @required this.fishingTypes,
  });

  final String title;
  final String attribute;
  final List<FishingTypes> fishingTypes;

  final ReCase coarse = ReCase(describeEnum(FishingTypes.coarse));
  final ReCase match = ReCase(describeEnum(FishingTypes.match));
  final ReCase fly = ReCase(describeEnum(FishingTypes.fly));
  final ReCase carp = ReCase(describeEnum(FishingTypes.carp));
  final ReCase catfish = ReCase(describeEnum(FishingTypes.catfish));

  List<FormBuilderFieldOption> _options() {
    return fishingTypes.map((type) =>
        FormBuilderFieldOption(
        value: ReCase(describeEnum(type)).snakeCase,
        child: Text(ReCase(describeEnum(type)).titleCase),
      )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle(title),
        FormBuilderCheckboxGroup(
          name: attribute,
          orientation: OptionsOrientation.vertical,
          options: _options(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
