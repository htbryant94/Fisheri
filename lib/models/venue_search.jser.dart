// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_search.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$VenueSearchJSONSerializer implements Serializer<VenueSearch> {
  Serializer<VenueAddress> __venueAddressJSONSerializer;
  Serializer<VenueAddress> get _venueAddressJSONSerializer =>
      __venueAddressJSONSerializer ??= VenueAddressJSONSerializer();
  @override
  Map<String, dynamic> toMap(VenueSearch model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'image_url', model.imageURL);
    setMapValue(ret, 'isLake', model.isLake);
    setMapValue(ret, 'isShop', model.isShop);
    setMapValue(
        ret, 'address', _venueAddressJSONSerializer.toMap(model.address));
    setMapValue(ret, 'amenities',
        codeIterable(model.amenities, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'fish_stocked',
        codeIterable(model.fishStocked, (val) => passProcessor.serialize(val)));
    setMapValue(
        ret,
        'fishing_types',
        codeIterable(
            model.fishingTypes, (val) => passProcessor.serialize(val)));
    return ret;
  }

  @override
  VenueSearch fromMap(Map map) {
    if (map == null) return null;
    final obj = VenueSearch();
    obj.name = map['name'] as String;
    obj.id = map['id'] as String;
    obj.imageURL = map['image_url'] as String;
    obj.isLake = map['isLake'] as bool;
    obj.isShop = map['isShop'] as bool;
    obj.address = _venueAddressJSONSerializer.fromMap(map['address'] as Map);
    obj.amenities = codeIterable<dynamic>(
        map['amenities'] as Iterable, (val) => passProcessor.deserialize(val));
    obj.fishStocked = codeIterable<dynamic>(map['fish_stocked'] as Iterable,
        (val) => passProcessor.deserialize(val));
    obj.fishingTypes = codeIterable<dynamic>(map['fishing_types'] as Iterable,
        (val) => passProcessor.deserialize(val));
    return obj;
  }
}
