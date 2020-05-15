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
    'fishingTypes': EnDecode(alias: 'fishing_types'),
    'imageURL': EnDecode(alias: 'image_url'),
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
    this.isLake,
    this.isShop,
    this.address,
    this.amenities,
    this.fishStocked,
    this.fishingTypes,
  });

  String name;
  String id;
  String imageURL;
  List<dynamic> categories;
  bool isLake;
  bool isShop;
  VenueAddress address;
  List<dynamic> amenities;
  List<dynamic> fishStocked;
  List<dynamic> fishingTypes;
}