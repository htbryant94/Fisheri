import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Screens/holiday_countries_screen.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';

class HolidayDetailed {
  HolidayDetailed({
    this.coordinates,
    this.country,
    this.name,
    this.airport,
    this.distanceFromAirport,
    this.difficulty,
    this.fishStocked,
    this.largestCarp,
    this.largestCatfish,
    this.maxAnglers,
    this.lakeSize,
    this.description,
    this.priceInfo,
    this.amenities,
    this.address,
    this.images,
    this.videos,
    this.contactDetails,
    this.fishingRules,
    this.social,
    this.websiteURL,
    this.bookingURL,
});

  GeoPoint coordinates;
  String country;
  String name;
  String airport;
  String distanceFromAirport;
  FishingDifficulty difficulty;
  List<String> fishStocked;
  String largestCarp;
  String largestCatfish;
  int maxAnglers;
  int lakeSize;
  String description;
  String priceInfo;
  List<String> amenities;
  VenueAddress address;
  List<String> images;
  List<String> videos;
  ContactDetails contactDetails;
  List<String> fishingRules;
  Social social;
  String websiteURL;
  String bookingURL;
}