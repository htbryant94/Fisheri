// @dart=2.9

import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class Stat {
  Stat({
    this.value,
    this.name,
  });

  final int value;
  final String name;
}

class StatsSection extends StatelessWidget {
  StatsSection({this.stats});

  final List<Stat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((stat) =>
          _StatItem(stat: stat)
      ).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  _StatItem({this.stat});

  final Stat stat;

  String _presentableValue(int value) {
    final RegExp expression = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return value.toString().replaceAllMapped(expression, (match) => '${match[1]},');
  }
  
  Widget _presentableName(String name) {
    final List<String> splitName = name.split(" ");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: splitName.map((item) => DSComponents.bodySmall(text: item)).toList(),
    );
  }

  String _getImageName(String name) {
    return ReCase(name).snakeCase;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('images/icons/${_getImageName(stat.name)}.png', fit: BoxFit.contain),
        DSComponents.singleSpacer(),
        DSComponents.header(text: _presentableValue(stat.value)),
        DSComponents.singleSpacer(),
        _presentableName(stat.name),
      ],
    );
  }
}

