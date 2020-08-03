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
    'operationalHours': EnDecode(alias: 'hours_of_operation'),
    'websiteURL': EnDecode(alias: 'website_url'),
    'numberOfLakes': EnDecode(alias: 'number_of_lakes'),
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
    this.fishingRules,
  });

  @pass
  GeoPoint coordinates;
  String name;
  List<String> images;
  List<dynamic> categories;
  String description;
  String websiteURL;
  VenueAddress address;
  ContactDetails contactDetails;
  Social social;
  int numberOfLakes;
  List<dynamic> amenities;
  List<dynamic> fishStocked;
  List<dynamic> fishingTackles;
  List<dynamic> fishingTypes;
  List<dynamic> tickets;
  HoursOfOperation operationalHours;
  String fishingRules;
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
