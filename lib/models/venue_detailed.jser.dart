// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_detailed.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$VenueDetailedJSONSerializer
    implements Serializer<VenueDetailed> {
  final _passProcessor = const PassProcessor();
  Serializer<VenueAddress> __venueAddressJSONSerializer;
  Serializer<VenueAddress> get _venueAddressJSONSerializer =>
      __venueAddressJSONSerializer ??= VenueAddressJSONSerializer();
  Serializer<ContactDetails> __contactDetailsJSONSerializer;
  Serializer<ContactDetails> get _contactDetailsJSONSerializer =>
      __contactDetailsJSONSerializer ??= ContactDetailsJSONSerializer();
  Serializer<Social> __socialJSONSerializer;
  Serializer<Social> get _socialJSONSerializer =>
      __socialJSONSerializer ??= SocialJSONSerializer();
  Serializer<HoursOfOperation> __hoursOfOperationJSONSerializer;
  Serializer<HoursOfOperation> get _hoursOfOperationJSONSerializer =>
      __hoursOfOperationJSONSerializer ??= HoursOfOperationJSONSerializer();
  @override
  Map<String, dynamic> toMap(VenueDetailed model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'coordinates', _passProcessor.serialize(model.coordinates));
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'image_url', model.imageURL);
    setMapValue(ret, 'isLake', model.isLake);
    setMapValue(ret, 'isShop', model.isShop);
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'website_url', model.websiteURL);
    setMapValue(ret, 'assets_path', model.assetsPath);
    setMapValue(
        ret, 'address', _venueAddressJSONSerializer.toMap(model.address));
    setMapValue(ret, 'contact_details',
        _contactDetailsJSONSerializer.toMap(model.contactDetails));
    setMapValue(ret, 'social', _socialJSONSerializer.toMap(model.social));
    setMapValue(ret, 'amenities_array',
        codeIterable(model.amenities, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'fish_stock_array',
        codeIterable(model.fishStocked, (val) => passProcessor.serialize(val)));
    setMapValue(
        ret,
        'fishing_types_array',
        codeIterable(
            model.fishingTypes, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'tickets_array',
        codeIterable(model.tickets, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'hours_of_operation_map',
        _hoursOfOperationJSONSerializer.toMap(model.operationalHours));
    setMapValue(ret, 'fishing_rules', model.fishingRules);
    return ret;
  }

  @override
  VenueDetailed fromMap(Map map) {
    if (map == null) return null;
    final obj = VenueDetailed();
    obj.coordinates =
        _passProcessor.deserialize(map['coordinates']) as GeoPoint;
    obj.name = map['name'] as String;
    obj.imageURL = map['image_url'] as String;
    obj.isLake = map['isLake'] as bool;
    obj.isShop = map['isShop'] as bool;
    obj.description = map['description'] as String;
    obj.websiteURL = map['website_url'] as String;
    obj.assetsPath = map['assets_path'] as String;
    obj.address = _venueAddressJSONSerializer.fromMap(map['address'] as Map);
    obj.contactDetails =
        _contactDetailsJSONSerializer.fromMap(map['contact_details'] as Map);
    obj.social = _socialJSONSerializer.fromMap(map['social'] as Map);
    obj.amenities = codeIterable<dynamic>(map['amenities_array'] as Iterable,
        (val) => passProcessor.deserialize(val));
    obj.fishStocked = codeIterable<dynamic>(map['fish_stock_array'] as Iterable,
        (val) => passProcessor.deserialize(val));
    obj.fishingTypes = codeIterable<dynamic>(
        map['fishing_types_array'] as Iterable,
        (val) => passProcessor.deserialize(val));
    obj.tickets = codeIterable<dynamic>(map['tickets_array'] as Iterable,
        (val) => passProcessor.deserialize(val));
    obj.operationalHours = _hoursOfOperationJSONSerializer
        .fromMap(map['hours_of_operation_map'] as Map);
    obj.fishingRules = map['fishing_rules'] as String;
    return obj;
  }
}

abstract class _$ContactDetailsJSONSerializer
    implements Serializer<ContactDetails> {
  @override
  Map<String, dynamic> toMap(ContactDetails model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'email', model.email);
    setMapValue(ret, 'phone', model.phone);
    return ret;
  }

  @override
  ContactDetails fromMap(Map map) {
    if (map == null) return null;
    final obj = ContactDetails();
    obj.email = map['email'] as String;
    obj.phone = map['phone'] as String;
    return obj;
  }
}

abstract class _$SocialJSONSerializer implements Serializer<Social> {
  @override
  Map<String, dynamic> toMap(Social model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'facebook', model.facebook);
    setMapValue(ret, 'instagram', model.instagram);
    setMapValue(ret, 'twitter', model.twitter);
    setMapValue(ret, 'youtube', model.youtube);
    return ret;
  }

  @override
  Social fromMap(Map map) {
    if (map == null) return null;
    final obj = Social();
    obj.facebook = map['facebook'] as String;
    obj.instagram = map['instagram'] as String;
    obj.twitter = map['twitter'] as String;
    obj.youtube = map['youtube'] as String;
    return obj;
  }
}
