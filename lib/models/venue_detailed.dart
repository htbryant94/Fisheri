import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'venue_detailed.jser.dart';

@GenSerializer(
  serializers: [
    ContactDetailsJSONSerializer,
    SocialJSONSerializer,
  ],
  fields: {
    'contactDetails': EnDecode(alias: 'contact_details'),
    'fishingRules': EnDecode(alias: 'fishing_rules'),
    'fishingTackles': EnDecode(alias: 'fishing_tackles'),
    'fishingTypes': EnDecode(alias: 'fishing_types'),
    'fishStocked': EnDecode(alias: 'fish_stock_array'),
    'fishStock': EnDecode(alias: 'fish_stock'),
    'operationalHours': EnDecode(alias: 'hours_of_operation'),
    'websiteURL': EnDecode(alias: 'website_url'),
    'numberOfLakes': EnDecode(alias: 'number_of_lakes'),
    'alwaysOpen': EnDecode(alias: 'always_open'),
  },
)
class VenueDetailedJSONSerializer extends Serializer<VenueDetailed>
    with _$VenueDetailedJSONSerializer {}

class VenueDetailed {
  VenueDetailed({
    this.coordinates,
    this.name,
    this.images,
    this.categories,
    this.description,
    this.websiteURL,
    this.address,
    this.contactDetails,
    this.social,
    this.numberOfLakes,
    this.amenities,
    this.fishStocked,
    this.fishingTackles,
    this.fishingTypes,
    this.tickets,
    this.operationalHours,
    this.alwaysOpen,
    this.fishingRules,
  });

  @pass
  GeoPoint coordinates;
  String name;
  List<String> images;
  List<String> categories;
  String description;
  String websiteURL;
  VenueAddress address;
  ContactDetails contactDetails;
  Social social;
  int numberOfLakes;
  List<String> amenities;
  List<String> fishStocked;
  List<String> fishingTackles;
  List<String> fishingTypes;
  List<String> tickets;
  HoursOfOperation operationalHours;
  bool alwaysOpen;
  String fishingRules;
  List<FishStock> fishStock;
}

@GenSerializer()
class FishStockJSONSerializer extends Serializer<FishStock>
    with _$FishStockJSONSerializer {}

class FishStock {
  FishStock({
    this.name,
    this.weight,
});

  String name;
  int weight;
  int priority;
}

@GenSerializer()
class ContactDetailsJSONSerializer extends Serializer<ContactDetails>
    with _$ContactDetailsJSONSerializer {}

class ContactDetails {
  ContactDetails({
    this.email,
    this.phone,
  });

  String email;
  String phone;
}

@GenSerializer()
class SocialJSONSerializer extends Serializer<Social>
    with _$SocialJSONSerializer {}

class Social {
  Social({
    this.facebook,
    this.instagram,
    this.twitter,
    this.youtube,
  });

  String facebook;
  String instagram;
  String twitter;
  String youtube;
}
