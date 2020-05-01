import 'package:fisheri/Screens/search_results_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

enum HolidayCountries {
  belgium,
  croatia,
  france,
  germany,
  netherlands,
  spain
}

enum FishingDifficulty {
  amateur,
  intermediate,
  professional,
}

class HolidayListing {
  HolidayListing({
    this.name,
    this.country,
    this.region,
    this.lakeSize,
    this.difficulty,
});

  final String name;
  final HolidayCountries country;
  final String region;
  final String lakeSize;
  final FishingDifficulty difficulty;
}

class HolidayCountriesScreen extends StatelessWidget {

  final List<HolidayListing> franceResults = [
    HolidayListing(
      name: "Le Grand Etang",
      country: HolidayCountries.france,
      region: "Calais",
      lakeSize: "56 acres",
      difficulty: FishingDifficulty.professional,
    ),
    HolidayListing(
      name: "Jurassik Carpe 1",
      country: HolidayCountries.france,
      region: "Calais",
      lakeSize: "190 acres",
      difficulty: FishingDifficulty.professional,
    ),
    HolidayListing(
      name: "Estate Lake",
      country: HolidayCountries.france,
      region: "Calais",
      lakeSize: "15 acres",
      difficulty: FishingDifficulty.intermediate,
    ),
    HolidayListing(
      name: "Lac de Viennay - Busters Lake",
      country: HolidayCountries.france,
      region: "Calais",
      lakeSize: "8 acres",
      difficulty: FishingDifficulty.amateur,
    ),
    HolidayListing(
      name: "Etang des Châteliers",
      country: HolidayCountries.france,
      region: "Calais",
      lakeSize: "60 acres",
      difficulty: FishingDifficulty.professional,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Wrap(
        children: [
          _FlagItem(
            flag: 'france',
            results: franceResults.map(
                    (holiday) => ListViewItem(
                      title: holiday.name,
                      subtitle: holiday.region,
                      additionalInformation: [
                        holiday.lakeSize,
                        StringUtils.capitalize(describeEnum(holiday.difficulty)),
                      ]
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
