import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Screens/venue_form_edit_screen.dart';
import 'package:fisheri/types/amenities.dart';
import 'package:fisheri/types/fish_stock_list.dart';
import 'package:flutter/foundation.dart';
import 'package:recase/recase.dart';

import 'Factories/fish_stock_factory.dart';
import 'models/holiday_detailed.dart';
import 'models/venue_address.dart';
import 'models/venue_detailed.dart';

class HolidayData {

  static final List<HolidayDetailed> franceResults = [
    _giganticaMain,
    _giganticaRoad,
  ];

  static final List<HolidayDetailed> belgiumResults = [
    _carpinsula,
  ];

  static final _giganticaMain = HolidayDetailed(
    country: 'France',
    name: 'Gigantica (Main Lake)',
    distanceFromCalais: '245',
    bookingURL: 'http://www.gigantica-carp.com/availability',
    difficulty: FishingDifficulty.hard,
    fishStocked: [
      FishStockFactory.make(FishStockList.commonCarp, null),
      FishStockFactory.make(FishStockList.mirrorCarp, null),
    ],
    largestCarp: '96Ib 8oz',
    largestCatfish: null,
    maxAnglers: 12,
    description: 'Gigantica is and always will be a serious carp water for the dedicated carp angler wishing to fish a \'proper\' lake with plenty of room. Since we took ownership, we have dropped the swims from 26 to 12. These changes have resulted in huge growth rates for the fish with several fish putting on 20lb+ between captures. There are 500-600 fish available and now with our largest fish being over 90lb. The list of big fish is growing by the day, and we have now firmly established ourselves as the ultimate holiday venue in Europe. Comfortable fishing for huge, catchable carp, in stunning surroundings. What more do you want?',
    priceInfo: 'from £495',
    amenities: [
      ReCase(describeEnum(Amenities.toilets)).snakeCase,
      ReCase(describeEnum(Amenities.showers)).snakeCase,
      ReCase(describeEnum(Amenities.baitFreezer)).snakeCase,
      ReCase(describeEnum(Amenities.tackleShop)).snakeCase,
      ReCase(describeEnum(Amenities.bait)).snakeCase,
      ReCase(describeEnum(Amenities.food)).snakeCase,
      ReCase(describeEnum(Amenities.snacks)).snakeCase,
      ReCase(describeEnum(Amenities.beverages)).snakeCase,
      ReCase(describeEnum(Amenities.tackleHire)).snakeCase,
      ReCase(describeEnum(Amenities.carpCareEquipmentProvided)).snakeCase,
    ],
    coordinates: GeoPoint(48.437283, 4.461145),
    address: VenueAddress(
        street: 'Gigantica',
        town: 'Domaine Saint Christophe',
        county: 'Saint Christophe Dodinicourt',
        postcode: '10500'
    ),
    images: [
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_main%2F0.jpg?alt=media&token=a25bff00-c53c-4397-985d-206b697c1f9c',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_main%2F1.jpg?alt=media&token=7bba9164-21db-4325-849d-b2c6fd90b7ac',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_main%2F2.jpg?alt=media&token=7bba9164-21db-4325-849d-b2c6fd90b7ac',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_main%2F3.jpg?alt=media&token=7bba9164-21db-4325-849d-b2c6fd90b7ac',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_main%2F4.jpg?alt=media&token=7bba9164-21db-4325-849d-b2c6fd90b7ac',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_main%2F5.jpg?alt=media&token=7bba9164-21db-4325-849d-b2c6fd90b7ac',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_main%2F6.jpg?alt=media&token=7bba9164-21db-4325-849d-b2c6fd90b7ac',

    ],
    videos: null,
    fishingRules: [
      'Every carp must be weighed and photographed on both sides. Enter the details onto the catch report forms provided.',
      'Bream & Tench - place in a keepnet or retainer and inform the bailiff.',
      'Maximum of three rods per angler. All in the same swim.',
      'Do not cut back tree branches or vegetation.',
      'Please leave the toilet and shower facilities in a clean and tidy condition.',
      'Drug and Alcohol abuse is not tolerated, those found highly intoxicated will be asked to leave, and placed on a collective fishery ‘black list’.',
      'No fires, including all forms of BBQ/fire pit.',
      'All vehicles must be parked in the designated car parks after unloading. The track must be kept clear at all times.',
      'Anglers must leave the lake by 10am on Saturday following their session.',
    ],
    contactDetails: ContactDetails(
        email: 'bookings@gigantica-carp.com',
        phone: '(+44)01268820440'
    ),
    websiteURL: 'www.gigantica-carp.com',
    social: Social(
      facebook: 'giganticacarp',
      instagram: 'gigantica.carp?igshid=13qoxv7eju4nz',
      youtube: 'kordatv',
    ),
  );

  static final _giganticaRoad = HolidayDetailed(
    country: 'France',
    name: 'Gigantica (Road Lake)',
    distanceFromCalais: '245',
    bookingURL: 'http://www.gigantica-carp.com/availability',
    difficulty: FishingDifficulty.moderate,
    fishStocked: [
      FishStockFactory.make(FishStockList.commonCarp, null),
      FishStockFactory.make(FishStockList.mirrorCarp, null),
    ],
    largestCarp: '65Ib',
    largestCatfish: null,
    maxAnglers: 12,
    description: 'Gigantica is and always will be a serious carp water for the dedicated carp angler wishing to fish a \'proper\' lake with plenty of room. Since we took ownership, we have dropped the swims from 26 to 12. These changes have resulted in huge growth rates for the fish with several fish putting on 20lb+ between captures. There are 500-600 fish available and now with our largest fish being over 90lb. The list of big fish is growing by the day, and we have now firmly established ourselves as the ultimate holiday venue in Europe. Comfortable fishing for huge, catchable carp, in stunning surroundings. What more do you want?',
    priceInfo: 'from £595',
    amenities: [
      ReCase(describeEnum(Amenities.toilets)).snakeCase,
      ReCase(describeEnum(Amenities.showers)).snakeCase,
      ReCase(describeEnum(Amenities.baitFreezer)).snakeCase,
      ReCase(describeEnum(Amenities.tackleShop)).snakeCase,
      ReCase(describeEnum(Amenities.bait)).snakeCase,
      ReCase(describeEnum(Amenities.food)).snakeCase,
      ReCase(describeEnum(Amenities.snacks)).snakeCase,
      ReCase(describeEnum(Amenities.beverages)).snakeCase,
      ReCase(describeEnum(Amenities.tackleHire)).snakeCase,
      ReCase(describeEnum(Amenities.carpCareEquipmentProvided)).snakeCase,
    ],
    coordinates: GeoPoint(48.437283, 4.461145),
    address: VenueAddress(
        street: 'Gigantica',
        town: 'Domaine Saint Christophe',
        county: 'Saint Christophe Dodinicourt',
        postcode: '10500'
    ),
    images: [
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_road%2F0.jpg?alt=media&token=1fd0aeef-f2d3-4132-a374-dca5a835a08e',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_road%2F1.jpg?alt=media&token=1fd0aeef-f2d3-4132-a374-dca5a835a08e',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_road%2F2.jpg?alt=media&token=1fd0aeef-f2d3-4132-a374-dca5a835a08e',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_road%2F3.jpg?alt=media&token=1fd0aeef-f2d3-4132-a374-dca5a835a08e',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_road%2F4.jpg?alt=media&token=1fd0aeef-f2d3-4132-a374-dca5a835a08e',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fgigantica_road%2F5.jpg?alt=media&token=1fd0aeef-f2d3-4132-a374-dca5a835a08e',
    ],
    videos: null,
    fishingRules: [
      'Every carp must be weighed and photographed on both sides. Enter the details onto the catch report forms provided.',
      'Bream & Tench - place in a keepnet or retainer and inform the bailiff.',
      'Maximum of three rods per angler. All in the same swim.',
      'Do not cut back tree branches or vegetation.',
      'Please leave the toilet and shower facilities in a clean and tidy condition.',
      'Drug and Alcohol abuse is not tolerated, those found highly intoxicated will be asked to leave, and placed on a collective fishery ‘black list’.',
      'No fires, including all forms of BBQ/fire pit.',
      'All vehicles must be parked in the designated car parks after unloading. The track must be kept clear at all times.',
      'Anglers must leave the lake by 10am on Saturday following their session.',
    ],
    contactDetails: ContactDetails(
        email: 'bookings@gigantica-carp.com',
        phone: '(+44)01268820440'
    ),
    websiteURL: 'www.gigantica-carp.com',
    social: Social(
      facebook: 'www.facebook.com/giganticacarp',
      instagram: 'www.instagram.com/gigantica.carp?igshid=13qoxv7eju4nz',
      youtube: 'www.youtube.com/kordatv',
    ),
  );

  static final _carpinsula = HolidayDetailed(
    country: 'Belgium',
    name: 'Carpinsula',
    distanceFromCalais: '145',
    bookingURL: 'https://www.thecarpspecialist.co.uk/carp-lakes/carpinsula-belly-pool',
    difficulty: FishingDifficulty.easyToHard,
    fishStocked: [
      FishStockFactory.make(FishStockList.commonCarp, null),
      FishStockFactory.make(FishStockList.mirrorCarp, null),
      FishStockFactory.make(FishStockList.grassCarp, null),
      FishStockFactory.make(FishStockList.welsCatfish, null),
    ],
    largestCarp: '44Ib',
    largestCatfish: '65Ib',
    maxAnglers: 2,
    description: 'It was only in 2015 that Jelle, the owner, started his lifetime project in an abandoned nature reserve in Belgium named Carpinsula. He turned this no man land into a real carp fishing paradise with only one goal in mind; bringing carp fishing and nature together with leaving the smallest footprint possible! After three years of intense preparations, it is Jelle\'s pleasure to introduce to you 5 different idyllic lakes. All available for a maximum of two anglers!',
    priceInfo: 'from EUR 137.50',
    amenities: [
      ReCase(describeEnum(Amenities.toilets)).snakeCase,
      ReCase(describeEnum(Amenities.tackleHire)).snakeCase,
      ReCase(describeEnum(Amenities.carpCareEquipmentProvided)).snakeCase,
    ],
    coordinates: GeoPoint(50.923552, 4.746405),
    address: VenueAddress(
        street: 'Carpinsula',
        town: 'Holsbeek',
        county: null,
        postcode: '3220'
    ),
    images: [
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fcarpinsula%2F0.jpg?alt=media&token=7464a05b-65ab-498e-ab89-99094502e805',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fcarpinsula%2F1.jpg?alt=media&token=7464a05b-65ab-498e-ab89-99094502e805',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fcarpinsula%2F2.jpg?alt=media&token=7464a05b-65ab-498e-ab89-99094502e805',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fcarpinsula%2F3.jpg?alt=media&token=7464a05b-65ab-498e-ab89-99094502e805',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fcarpinsula%2F4.jpg?alt=media&token=7464a05b-65ab-498e-ab89-99094502e805',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fcarpinsula%2F5.jpg?alt=media&token=7464a05b-65ab-498e-ab89-99094502e805',
      'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/holidays%2Fcarpinsula%2F6.jpg?alt=media&token=7464a05b-65ab-498e-ab89-99094502e805',
    ],
    videos: null,
    fishingRules: null,
    contactDetails: ContactDetails(
        email: 'info@thecarpspecialist.co.uk',
        phone: null,
    ),
    websiteURL: 'www.thecarpspecialist.co.uk/carp-lakes/carpinsula-belly-pool',
    social: Social(
      facebook: 'carpinsula-102800484650513',
      instagram: 'carpinsula?igshid=1qtx25uyds68f',
      youtube: 'watch?v=GXRoRF7AwGY',
    ),
  );
}

enum HolidayCountries {
  belgium,
  croatia,
  france,
  germany,
  netherlands,
  spain
}