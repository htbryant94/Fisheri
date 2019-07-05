import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

class VenueAddress {
  VenueAddress(String street, String town, String county, String postcode) {
    this.street = street;
    this.town = town;
    this.county = county;
    this.postcode = postcode;
  }

  String street;
  String town;
  String county;
  String postcode;
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

class VenueFishStock {
  VenueFishStock(
      FishWithWeight carp,
      FishWithWeight catfish,
      FishWithWeight tench,
      FishWithWeight pike,
      FishWithWeight bream,
      FishWithWeight barbel,
      bool brownTrout,
      bool chub,
      bool crucianCarp,
      bool dace,
      bool eel,
      bool grassCarp,
      bool grayling,
      bool gudgeon,
      bool koiCarp,
      bool orfe,
      bool perch,
      bool rainbowTrout,
      bool roach,
      bool rudd,
      bool ruffe,
      bool salmon,
      bool zander) {
    this.carp = carp;
    this.catfish = catfish;
    this.tench = tench;
    this.pike = pike;
    this.bream = bream;
    this.barbel = barbel;
    this.brownTrout = brownTrout;
    this.chub = chub;
    this.crucianCarp = crucianCarp;
    this.dace = dace;
    this.eel = eel;
    this.grassCarp = grassCarp;
    this.grayling = grayling;
    this.gudgeon = gudgeon;
    this.koiCarp = koiCarp;
    this.orfe = orfe;
    this.perch = perch;
    this.rainbowTrout = rainbowTrout;
    this.roach = roach;
    this.rudd = rudd;
    this.ruffe = ruffe;
    this.salmon = salmon;
    this.zander = zander;
  }

  FishWithWeight carp;
  FishWithWeight catfish;
  FishWithWeight tench;
  FishWithWeight pike;
  FishWithWeight bream;
  FishWithWeight barbel;
  bool brownTrout;
  bool chub;
  bool crucianCarp;
  bool dace;
  bool eel;
  bool grassCarp;
  bool grayling;
  bool gudgeon;
  bool koiCarp;
  bool orfe;
  bool perch;
  bool rainbowTrout;
  bool roach;
  bool rudd;
  bool ruffe;
  bool salmon;
  bool zander;
}

class FishWithWeight {
  FishWithWeight(String name, int maxWeight);

  String name;
  int maxWeight;
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
  HoursOfOperationDay(String day, String open, String close) {
    this.day = day;
    this.open = open;
    this.close = close;
  }

  String day;
  String open;
  String close;
}
