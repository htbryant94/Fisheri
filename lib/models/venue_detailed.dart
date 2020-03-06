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
    'websiteURL': EnDecode(alias: 'website_url'),
    'assetsPath': EnDecode(alias: 'assets_path'),
    'contactDetails': EnDecode(alias: 'contact_details'),
    'amenities': EnDecode(alias: 'amenities_array'),
    'fishStocked': EnDecode(alias: 'fish_stock_array'),
    'fishingTypes': EnDecode(alias: 'fishing_types_array'),
    'operationalHours': EnDecode(alias: 'hours_of_operation_map'),
    'tickets': EnDecode(alias: 'tickets_array'),
    'fishingRules': EnDecode(alias: 'fishing_rules'),
  },
)
class VenueDetailedJSONSerializer extends Serializer<VenueDetailed>
    with _$VenueDetailedJSONSerializer {}

class VenueDetailed {
  VenueDetailed({
    this.coordinates,
    this.name,
    this.isLake,
    this.isShop,
    this.description,
    this.websiteURL,
    this.assetsPath,
    this.address,
    this.contactDetails,
    this.social,
    this.amenities,
    this.fishStocked,
    this.fishingTypes,
    this.tickets,
    this.operationalHours,
    this.fishingRules,
  });

  @pass
  GeoPoint coordinates;
  String name;
  bool isLake;
  bool isShop;
  String description;
  String websiteURL;
  String assetsPath;
  VenueAddress address;
  ContactDetails contactDetails;
  Social social;
  List<dynamic> amenities;
  List<dynamic> fishStocked;
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
