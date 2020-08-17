import 'package:fisheri/models/venue_address.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'venue_search.jser.dart';

@GenSerializer(
  serializers: [
    VenueAddressJSONSerializer,
  ],
  fields: {
    'amenities': EnDecode(alias: 'amenities'),
    'fishStocked': EnDecode(alias: 'fish_stocked'),
    'fishingTackles': EnDecode(alias: 'fishing_tackles'),
    'fishingTypes': EnDecode(alias: 'fishing_types'),
    'imageURL': EnDecode(alias: 'image_url'),
    'numberOfLakes': EnDecode(alias: 'number_of_lakes'),
    'alwaysOpen': EnDecode(alias: 'always_open'),
  },
)
class VenueSearchJSONSerializer extends Serializer<VenueSearch>
    with _$VenueSearchJSONSerializer {}

class VenueSearch {
  VenueSearch({
    this.name,
    this.id,
    this.imageURL,
    this.categories,
    this.address,
    this.numberOfLakes,
    this.amenities,
    this.fishStocked,
    this.fishingTackles,
    this.fishingTypes,
    this.alwaysOpen,
  });

  String name;
  String id;
  String imageURL;
  List<dynamic> categories;
  VenueAddress address;
  int numberOfLakes;
  List<dynamic> amenities;
  List<dynamic> fishStocked;
  List<dynamic> fishingTackles;
  List<dynamic> fishingTypes;
  bool alwaysOpen;
}