import 'package:jaguar_serializer/jaguar_serializer.dart';
part 'venue_address.jser.dart';

@GenSerializer()
class VenueAddressJSONSerializer extends Serializer<VenueAddress>
    with _$VenueAddressJSONSerializer {}

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
