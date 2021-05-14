import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';

enum Filter {
  lake,
  shop
}

class SearchFilters {
  bool lake = false;
  bool shop = false;

  bool hasAppliedParameter() {
    return lake || shop;
  }
}

class SearchFilterScreen extends StatefulWidget {
  SearchFilterScreen({
    this.onChanged,
    this.onResetPressed,
    this.searchFilters,
  });

  ValueChanged<SearchFilters> onChanged;
  VoidCallback onResetPressed;
  SearchFilters searchFilters;

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  SearchFilters _searchFilters;

  @override
  void initState() {
    super.initState();
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
              DSComponents.sectionSpacer(),
              DSComponents.primaryButton(
                  text: 'Apply Filters',
                  onPressed: () {
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
