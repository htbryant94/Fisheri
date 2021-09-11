// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueSearch _$VenueSearchFromJson(Map<String, dynamic> json) {
  return VenueSearch(
    id: json['id'] as String?,
    address: json['address'] == null
        ? null
        : VenueAddress.fromJson(json['address'] as Map<String, dynamic>),
    alwaysOpen: json['always_open'] as bool?,
    amenities: json['amenities'] as List<dynamic>?,
    categories: json['categories'] as List<dynamic>?,
    fishStocked: json['fish_stocked'] as List<dynamic>?,
    fishingTackles: json['fishing_tackles'] as List<dynamic>?,
    fishingTypes: json['fishing_types'] as List<dynamic>?,
    imageURL: json['image_url'] as String?,
    name: json['name'] as String?,
    numberOfLakes: json['number_of_lakes'] as int?,
  );
}

Map<String, dynamic> _$VenueSearchToJson(VenueSearch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'always_open': instance.alwaysOpen,
      'amenities': instance.amenities,
      'categories': instance.categories,
      'fish_stocked': instance.fishStocked,
      'fishing_tackles': instance.fishingTackles,
      'fishing_types': instance.fishingTypes,
      'image_url': instance.imageURL,
      'name': instance.name,
      'number_of_lakes': instance.numberOfLakes,
    };
