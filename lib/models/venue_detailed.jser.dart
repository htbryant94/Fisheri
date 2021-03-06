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
  Serializer<FishStock> __fishStockJSONSerializer;
  Serializer<FishStock> get _fishStockJSONSerializer =>
      __fishStockJSONSerializer ??= FishStockJSONSerializer();
  @override
  Map<String, dynamic> toMap(VenueDetailed model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'coordinates', _passProcessor.serialize(model.coordinates));
    setMapValue(ret, 'name', model.name);
    setMapValue(
        ret, 'images', codeIterable(model.images, (val) => val as String));
    setMapValue(ret, 'categories',
        codeIterable(model.categories, (val) => val as String));
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'website_url', model.websiteURL);
    setMapValue(
        ret, 'address', _venueAddressJSONSerializer.toMap(model.address));
    setMapValue(ret, 'contact_details',
        _contactDetailsJSONSerializer.toMap(model.contactDetails));
    setMapValue(ret, 'social', _socialJSONSerializer.toMap(model.social));
    setMapValue(ret, 'number_of_lakes', model.numberOfLakes);
    setMapValue(ret, 'amenities',
        codeIterable(model.amenities, (val) => val as String));
    setMapValue(ret, 'fish_stock_array',
        codeIterable(model.fishStocked, (val) => val as String));
    setMapValue(ret, 'fishing_tackles',
        codeIterable(model.fishingTackles, (val) => val as String));
    setMapValue(ret, 'fishing_types',
        codeIterable(model.fishingTypes, (val) => val as String));
    setMapValue(
        ret, 'tickets', codeIterable(model.tickets, (val) => val as String));
    setMapValue(ret, 'hours_of_operation',
        _hoursOfOperationJSONSerializer.toMap(model.operationalHours));
    setMapValue(ret, 'always_open', model.alwaysOpen);
    setMapValue(ret, 'fishing_rules', model.fishingRules);
    setMapValue(
        ret,
        'fish_stock',
        codeIterable(model.fishStock,
            (val) => _fishStockJSONSerializer.toMap(val as FishStock)));
    return ret;
  }

  @override
  VenueDetailed fromMap(Map map) {
    if (map == null) return null;
    final obj = VenueDetailed();
    obj.coordinates =
        _passProcessor.deserialize(map['coordinates']) as GeoPoint;
    obj.name = map['name'] as String;
    obj.images =
        codeIterable<String>(map['images'] as Iterable, (val) => val as String);
    obj.categories = codeIterable<String>(
        map['categories'] as Iterable, (val) => val as String);
    obj.description = map['description'] as String;
    obj.websiteURL = map['website_url'] as String;
    obj.address = _venueAddressJSONSerializer.fromMap(map['address'] as Map);
    obj.contactDetails =
        _contactDetailsJSONSerializer.fromMap(map['contact_details'] as Map);
    obj.social = _socialJSONSerializer.fromMap(map['social'] as Map);
    obj.numberOfLakes = map['number_of_lakes'] as int;
    obj.amenities = codeIterable<String>(
        map['amenities'] as Iterable, (val) => val as String);
    obj.fishStocked = codeIterable<String>(
        map['fish_stock_array'] as Iterable, (val) => val as String);
    obj.fishingTackles = codeIterable<String>(
        map['fishing_tackles'] as Iterable, (val) => val as String);
    obj.fishingTypes = codeIterable<String>(
        map['fishing_types'] as Iterable, (val) => val as String);
    obj.tickets = codeIterable<String>(
        map['tickets'] as Iterable, (val) => val as String);
    obj.operationalHours = _hoursOfOperationJSONSerializer
        .fromMap(map['hours_of_operation'] as Map);
    obj.alwaysOpen = map['always_open'] as bool;
    obj.fishingRules = map['fishing_rules'] as String;
    obj.fishStock = codeIterable<FishStock>(map['fish_stock'] as Iterable,
        (val) => _fishStockJSONSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$FishStockJSONSerializer implements Serializer<FishStock> {
  @override
  Map<String, dynamic> toMap(FishStock model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'weight', model.weight);
    setMapValue(ret, 'priority', model.priority);
    return ret;
  }

  @override
  FishStock fromMap(Map map) {
    if (map == null) return null;
    final obj = FishStock();
    obj.name = map['name'] as String;
    obj.weight = map['weight'] as int;
    obj.priority = map['priority'] as int;
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
