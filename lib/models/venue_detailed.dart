import 'package:fisheri/models/venue_address.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
part 'venue_detailed.jser.dart';

@GenSerializer(
  serializers: const [
    ContactDetailsJSONSerializer,
    SocialJSONSerializer,
  ],
  fields: const {
    'websiteURL': EnDecode(alias: 'website_url'),
    'assetsPath': EnDecode(alias: 'assets_path'),
    'contactDetails': EnDecode(alias: 'contact_details'),
    'amenities': EnDecode(alias: 'amenities_array'),
    'fishStocked': EnDecode(alias: 'fish_stock_array'),
    'fishingTypes': EnDecode(alias: 'fishing_types_array'),
  },
)
class VenueDetailedJSONSerializer extends Serializer<VenueDetailed>
    with _$VenueDetailedJSONSerializer {}

class VenueDetailed {
  VenueDetailed({
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
  });

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
}

@GenSerializer()
class ContactDetailsJSONSerializer extends Serializer<ContactDetails>
    with _$ContactDetailsJSONSerializer {}

class ContactDetails {
  String email;
  String phone;
}

@GenSerializer()
class SocialJSONSerializer extends Serializer<Social>
    with _$SocialJSONSerializer {}

class Social {
  String facebook;
  String instagram;
  String twitter;
  String youtube;
}
