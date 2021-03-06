import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'models/venue_address.dart';
import 'models/venue_fish_stock.dart';

class ResultInfo {
  ResultInfo(String title, String distance, String location, bool isLake,
      bool isOpen) {
    this.title = title;
    this.distance = distance;
    this.location = location;
    this.isLake = isLake;
    this.isOpen = isOpen;
  }

  String title;
  String distance;
  String location;
  bool isLake;
  bool isOpen;
}

class MockResultInfo {
  MockResultInfo();

  static List<ResultInfo> searchResults = [
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
  ];
}

class VenueDetail {
  VenueDetail(
    String name,
    String description,
    String websiteURL,
    String assetsPath,
    bool isLake,
    bool isShop,
    GeoPoint coordinates,
    VenueAddress address,
    VenueAmenities amenities,
    VenueContactDetails contactDetails,
    VenueSocial social,
    VenueFishStock fishStock,
    FishingTypes fishingTypes,
    VenueTickets tickets,
    List<HoursOfOperationDay> hoursOfOperation,
  ) {
    this.name = name;
    this.description = description;
    this.websiteURL = websiteURL;
    this.assetsPath = assetsPath;
    this.isLake = isLake;
    this.isShop = isShop;
    this.coordinates = coordinates;
    this.address = address;
    this.amenities = amenities;
    this.contactDetails = contactDetails;
    this.social = social;
    this.fishStock = fishStock;
    this.fishingTypes = fishingTypes;
    this.tickets = tickets;
    this.hoursOfOperation = hoursOfOperation;
  }

  String name;
  String description;
  String websiteURL;
  String assetsPath;
  bool isLake;
  bool isShop;
  GeoPoint coordinates;
  VenueAddress address;
  VenueAmenities amenities;
  VenueContactDetails contactDetails;
  VenueSocial social;
  VenueFishStock fishStock;
  FishingTypes fishingTypes;
  VenueTickets tickets;
  List<HoursOfOperationDay> hoursOfOperation;
}

class VenueAmenities {
  VenueAmenities(
      bool toilets,
      bool showers,
      bool refreshments,
      bool nightFishing,
      bool wheelchairAccess,
      bool guestsAllowed,
      bool trolleyHire,
      bool takeawayFriendly,
      bool animalFriendly,
      bool tuition,
      bool electricity,
      bool equipmentHire,
      bool wifi,
      bool camping) {
    this.toilets = toilets;
    this.showers = showers;
    this.refreshments = refreshments;
    this.nightFishing = nightFishing;
    this.wheelchairAccess = wheelchairAccess;
    this.guestsAllowed = guestsAllowed;
    this.trolleyHire = trolleyHire;
    this.takeawayFriendly = takeawayFriendly;
    this.animalFriendly = animalFriendly;
    this.tuition = tuition;
    this.electricity = electricity;
    this.equipmentHire = equipmentHire;
    this.wifi = wifi;
    this.camping = camping;
  }

  @required
  bool toilets;
  @required
  bool showers;
  @required
  bool refreshments;
  @required
  bool nightFishing;
  @required
  bool wheelchairAccess;
  @required
  bool guestsAllowed;
  @required
  bool trolleyHire;
  @required
  bool takeawayFriendly;
  @required
  bool animalFriendly;
  @required
  bool tuition;
  @required
  bool electricity;
  @required
  bool equipmentHire;
  @required
  bool wifi;
  @required
  bool camping;
}

class VenueContactDetails {
  VenueContactDetails(String email, String phone) {
    this.email = email;
    this.phone = phone;
  }

  String email;
  String phone;
}

class VenueSocial {
  VenueSocial(
      String facebook, String twitter, String instagram, String youtube) {
    this.facebook = facebook;
    this.twitter = twitter;
    this.instagram = instagram;
    this.youtube = youtube;
  }

  String facebook;
  String twitter;
  String instagram;
  String youtube;
}

class FishingTypes {
  FishingTypes(bool carp, bool catfish, bool coarse, bool fly, bool match,
      bool predator) {
    this.carp = carp;
    this.catfish = catfish;
    this.coarse = coarse;
    this.fly = fly;
    this.match = match;
    this.predator = predator;
  }

  @required
  bool carp;
  @required
  bool catfish;
  @required
  bool coarse;
  @required
  bool fly;
  @required
  bool match;
  @required
  bool predator;
}

class VenueTickets {
  VenueTickets(bool day, bool season, bool syndicate, bool club) {
    this.day = day;
    this.season = season;
    this.syndicate = syndicate;
    this.club = club;
  }

  bool day;
  bool season;
  bool syndicate;
  bool club;
}

class HoursOfOperationDay {
  HoursOfOperationDay({
    String day,
    String open,
    String close,
  }) {
    this.day = day;
    this.open = open;
    this.close = close;
  }

  String day;
  String open;
  String close;
}
