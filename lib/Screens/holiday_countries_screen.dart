import 'package:fisheri/Screens/search_results_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

import '../holiday_data.dart';

class HolidayCountriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Wrap(
        children: [
          _FlagItem(
            flag: 'france',
            results: HolidayData.franceResults.map(
                    (holiday) => ListViewItem(
                      title: holiday.name,
                      subtitle: holiday.airport,
                      additionalInformation: [
                        "${holiday.lakeSize} acres",
                        StringUtils.capitalize(describeEnum(holiday.difficulty)),
                      ],
                      venue: holiday
                    )
            ).toList(),
          ),
          _FlagItem(flag: 'croatia'),
          _FlagItem(flag: 'belgium'),
          _FlagItem(flag: 'netherlands'),
          _FlagItem(flag: 'spain'),
          _FlagItem(flag: 'germany'),
        ],
      ),
    )));
  }
}

class _FlagItem extends StatelessWidget {
  _FlagItem({
    this.flag,
    this.results,
  });

  final String flag;
  final List<ListViewItem> results;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (results != null) {
          Coordinator.pushListViewScreen(context, currentPageTitle: "Countries", items: results, nextPageTitle: "Holidays - France");
        }
      },
      child: Column(
        children: [
          Image.asset('images/flags/$flag.png',
              width: MediaQuery.of(context).size.width / 2),
          Text(StringUtils.capitalize(flag)),
        ],
      ),
    );
  }
}
