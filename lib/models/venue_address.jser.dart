// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_address.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$VenueAddressJSONSerializer
    implements Serializer<VenueAddress> {
  @override
  Map<String, dynamic> toMap(VenueAddress model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'street', model.street);
    setMapValue(ret, 'town', model.town);
    setMapValue(ret, 'county', model.county);
    setMapValue(ret, 'postcode', model.postcode);
    return ret;
  }

  @override
  VenueAddress fromMap(Map map) {
    if (map == null) return null;
    final obj = VenueAddress();
    obj.street = map['street'] as String;
    obj.town = map['town'] as String;
    obj.county = map['county'] as String;
    obj.postcode = map['postcode'] as String;
    return obj;
  }
}
