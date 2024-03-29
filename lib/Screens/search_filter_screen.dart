// @dart=2.9

import 'package:fisheri/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Filter {
  lake,
  shop
}

class SearchFilters {
  bool lake = false;
  bool shop = false;
  int searchRadius;

  bool hasAppliedParameter() {
    return lake || shop;
  }
}

class DistanceValue {
  DistanceValue(
      this.name,
      this.value
      );

  final String name;
  final int value;
}

class SearchFilterScreen extends StatefulWidget {
  SearchFilterScreen({
    this.onChanged,
    this.onResetPressed,
    this.searchFilters,
    this.searchRadiusChanged,
  });

  ValueChanged<SearchFilters> onChanged;
  VoidCallback onResetPressed;
  SearchFilters searchFilters;
  ValueChanged<int> searchRadiusChanged;

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  SearchFilters _searchFilters;
  double _currentSliderValue = 0;


  final _distanceValues = [
    DistanceValue('Within a mile', 1),
    DistanceValue('5 miles', 5),
    DistanceValue('10 miles', 10),
    DistanceValue('15 miles', 15),
    DistanceValue('20 miles', 20),
    DistanceValue('25 miles ', 25),
    DistanceValue('30 miles ', 30),
    DistanceValue('40 miles', 40),
    DistanceValue('50 miles', 50),
    DistanceValue('100 miles', 100),
    DistanceValue('Nationwide', 1000),
  ];

  String _distanceLabel(double sliderValue) {
    return _distanceValues[sliderValue.toInt()].name;
  }

  int _getIndexForDistanceValue(int distance) {
    if (distance != null) {
      print('distance not: $distance');
      return _distanceValues.indexWhere((distanceValue) =>
      distanceValue.value == distance
      );
    }
    return 2; // default 10 miles;
  }

  @override
  void initState() {
    super.initState();
    _currentSliderValue = _getIndexForDistanceValue(widget.searchFilters.searchRadius).toDouble();
    _searchFilters = widget.searchFilters;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              CheckboxListTile(
                  title: DSComponents.subheader(text: 'Lake'),
                  value: _searchFilters.lake,
                  onChanged: (isOn) {
                    setState(() {
                      _searchFilters.lake = isOn;
                    });
                    widget.onChanged(_searchFilters);
                  },
              ),
              CheckboxListTile(
                title: DSComponents.subheader(text: 'Shop'),
                value: _searchFilters.shop,
                onChanged: (isOn) {
                  setState(() {
                    _searchFilters.shop = isOn;
                  });
                  widget.onChanged(_searchFilters);
                },
              ),
              DSComponents.paragraphSpacer(),
              DSComponents.subheader(text: 'Search Radius'),
              Slider(
                value: _currentSliderValue,
                onChanged: (value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
                activeColor: DSColors.green,
                inactiveColor: DSColors.pastelGreen,
                min: 0,
                max: 10,
                divisions: 10,
              ),
              DSComponents.body(text: _distanceLabel(_currentSliderValue), alignment: Alignment.center),
              DSComponents.sectionSpacer(),
              DSComponents.primaryButton(
                  text: 'Apply Filters',
                  onPressed: () {
                    widget.searchRadiusChanged(_distanceValues[_currentSliderValue.toInt()].value);
                    Navigator.of(context).pop();
                  }
              ),
              DSComponents.paragraphSpacer(),
              DSComponents.secondaryButton(
                text: 'Reset Filters',
                onPressed: _searchFilters.hasAppliedParameter() ? () {
                  setState(() {
                    _searchFilters = SearchFilters();
                  });
                  widget.onResetPressed();
                } : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
