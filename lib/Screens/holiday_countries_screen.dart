import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Screens/search_results_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/models/holiday_detailed.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
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

  final List<HolidayDetailed> franceResults = [
    HolidayDetailed(
      country: "France",
      name: "Gigantica (Main Lake)",
      airport: "Calais",
      distanceFromAirport: "245",
      bookingURL: "http://www.gigantica-carp.com/availability",
      difficulty: FishingDifficulty.professional,
      fishStocked: ["common_carp", "mirror_carp"],
      largestCarp: "85lb",
      largestCatfish: null,
      maxAnglers: 12,
      lakeSize: 123,
      priceInfo: "from £495",
      amenities: ["toilets", "showers", "bait_freezer", "tackle_shop", "bait", "food", "snacks", "beverages", "tackle_hire", "carp_care_equipment_provided"],
      coordinates: GeoPoint(48.437283,  4.461145),
      address: VenueAddress(
        street: "Gigantica",
        town: "Domaine Saint Christophe",
        county: "Saint Christophe Dodinicourt",
        postcode: "10500"
      ),
      images: null,
      videos: null,
      fishingRules: [
        "Every carp must be weighed and photographed on both sides. Enter the details onto the catch report forms provided.",
        "Bream & Tench - place in a keepnet or retainer and inform the bailiff.",
        "Maximum of three rods per angler. All in the same swim.",
        "Do not cut back tree branches or vegetation.",
        "Please leave the toilet and shower facilities in a clean and tidy condition.",
        "Drug and Alcohol abuse is not tolerated, those found highly intoxicated will be asked to leave, and placed on a collective fishery ‘black list’.",
        "No fires, including all forms of BBQ/fire pit.",
        "All vehicles must be parked in the designated car parks after unloading. The track must be kept clear at all times.",
        "Anglers must leave the lake by 10am on Saturday following their session.",
      ],
      contactDetails: ContactDetails(
        email: "bookings@gigantica-carp.com",
        phone: "(+44)01268820440"
      ),
      social: Social(
        facebook: "www.facebook.com/giganticacarp",
        instagram: "www.instagram.com/gigantica.carp?igshid=13qoxv7eju4nz",
        youtube: "www.youtube.com/kordatv",
      ),
      description: "Gigantica is and always will be a serious carp water for the dedicated carp angler wishing to fish a 'proper' lake with plenty of room. Since we took ownership, we have dropped the swims from 26 to 12. These changes have resulted in huge growth rates for the fish with several fish putting on 20lb+ between captures. There are 500-600 fish available and now with our largest fish being over 90lb. The list of big fish is growing by the day, and we have now firmly established ourselves as the ultimate holiday venue in Europe. Comfortable fishing for huge, catchable carp, in stunning surroundings. What more do you want?",
    ),
  ];

//  final List<HolidayListing> franceResults = [
//    HolidayListing(
//      name: "Le Grand Etang",
//      country: HolidayCountries.france,
//      region: "Calais",
//      lakeSize: "56 acres",
//      difficulty: FishingDifficulty.professional,
//    ),
//    HolidayListing(
//      name: "Jurassik Carpe 1",
//      country: HolidayCountries.france,
//      region: "Calais",
//      lakeSize: "190 acres",
//      difficulty: FishingDifficulty.professional,
//    ),
//    HolidayListing(
//      name: "Estate Lake",
//      country: HolidayCountries.france,
//      region: "Calais",
//      lakeSize: "15 acres",
//      difficulty: FishingDifficulty.intermediate,
//    ),
//    HolidayListing(
//      name: "Lac de Viennay - Busters Lake",
//      country: HolidayCountries.france,
//      region: "Calais",
//      lakeSize: "8 acres",
//      difficulty: FishingDifficulty.amateur,
//    ),
//    HolidayListing(
//      name: "Etang des Châteliers",
//      country: HolidayCountries.france,
//      region: "Calais",
//      lakeSize: "60 acres",
//      difficulty: FishingDifficulty.professional,
//    ),
//  ];

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
