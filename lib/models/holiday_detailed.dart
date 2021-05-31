import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';

class HolidayDetailed {
  HolidayDetailed({
    this.country,
    this.name,
    this.distanceFromCalais,
    this.bookingURL,
    this.difficulty,
    this.fishStocked,
    this.largestCarp,
    this.largestCatfish,
    this.maxAnglers,
    this.description,
    this.priceInfo,
    this.amenities,
    this.coordinates,
    this.address,
    this.images,
    this.videos,
    this.fishingRules,
    this.contactDetails,
    this.websiteURL,
    this.social,
    this.isSponsored,
});

  String country;
  String name;
  String distanceFromCalais;
  String bookingURL;
  FishingDifficulty difficulty;
  List<FishStock> fishStocked;
  String largestCarp;
  String largestCatfish;
  int maxAnglers;
  String description;
  String priceInfo;
  List<String> amenities;
  GeoPoint coordinates;
  VenueAddress address;
  List<String> images;
  List<String> videos;
  List<String> fishingRules;
  ContactDetails contactDetails;
  String websiteURL;
  Social social;
  bool isSponsored;
}

enum FishingDifficulty {
  easy,
  moderate,
  hard,
  easyToHard,
}