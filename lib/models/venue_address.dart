import 'package:json_annotation/json_annotation.dart';
part 'venue_address.g.dart';

@JsonSerializable(explicitToJson: true)
class VenueAddress {
  VenueAddress({
    String? county,
    String? postcode,
    String? street,
    String? town,
  }) {
    this.county = county;
    this.postcode = postcode;
    this.street = street;
    this.town = town;
  }

  String? county;
  String? postcode;
  String? street;
  String? town;

  factory VenueAddress.fromJson(Map<String, dynamic> json) => _$VenueAddressFromJson(json);
  Map<String, dynamic> toJson() => _$VenueAddressToJson(this);
}
