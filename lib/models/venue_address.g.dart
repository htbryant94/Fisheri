// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueAddress _$VenueAddressFromJson(Map<String, dynamic> json) {
  return VenueAddress(
    county: json['county'] as String?,
    postcode: json['postcode'] as String?,
    street: json['street'] as String?,
    town: json['town'] as String?,
  );
}

Map<String, dynamic> _$VenueAddressToJson(VenueAddress instance) =>
    <String, dynamic>{
      'county': instance.county,
      'postcode': instance.postcode,
      'street': instance.street,
      'town': instance.town,
    };
