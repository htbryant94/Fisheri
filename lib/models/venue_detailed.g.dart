// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_detailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueDetailed _$VenueDetailedFromJson(Map<String, dynamic> json) {
  return VenueDetailed(
    id: json['id'] as String,
    address: json['address'] == null
        ? null
        : VenueAddress.fromJson(json['address'] as Map<String, dynamic>),
    alwaysOpen: json['always_open'] as bool?,
    amenities:
        (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList(),
    categories: (json['categories'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    contactDetails: json['contact_details'] == null
        ? null
        : ContactDetails.fromJson(
            json['contact_details'] as Map<String, dynamic>),
    description: json['description'] as String?,
    fishingRules: json['fishing_rules'] as String?,
    fishStock: (json['fish_stock'] as List<dynamic>?)
        ?.map((e) => FishStock.fromJson(e as Map<String, dynamic>))
        .toList(),
    fishStocked: (json['fish_stock_array'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    fishingTackles: (json['fishing_tackles'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    fishingTypes: (json['fishing_types'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    name: json['name'] as String?,
    numberOfLakes: json['number_of_lakes'] as int?,
    operationalHours: json['hours_of_operation'] == null
        ? null
        : HoursOfOperation.fromJson(
            json['hours_of_operation'] as Map<String, dynamic>),
    social: json['social'] == null
        ? null
        : Social.fromJson(json['social'] as Map<String, dynamic>),
    tickets:
        (json['tickets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    websiteURL: json['website_url'] as String?,
  );
}

Map<String, dynamic> _$VenueDetailedToJson(VenueDetailed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'always_open': instance.alwaysOpen,
      'amenities': instance.amenities,
      'categories': instance.categories,
      'contact_details': instance.contactDetails,
      'description': instance.description,
      'fishing_rules': instance.fishingRules,
      'fish_stock': instance.fishStock,
      'fish_stock_array': instance.fishStocked,
      'fishing_tackles': instance.fishingTackles,
      'fishing_types': instance.fishingTypes,
      'images': instance.images,
      'name': instance.name,
      'number_of_lakes': instance.numberOfLakes,
      'hours_of_operation': instance.operationalHours,
      'social': instance.social,
      'tickets': instance.tickets,
      'website_url': instance.websiteURL,
    };

FishStock _$FishStockFromJson(Map<String, dynamic> json) {
  return FishStock(
    name: json['name'] as String?,
    weight: json['weight'] as int?,
  )..priority = json['priority'] as int;
}

Map<String, dynamic> _$FishStockToJson(FishStock instance) => <String, dynamic>{
      'name': instance.name,
      'weight': instance.weight,
      'priority': instance.priority,
    };

ContactDetails _$ContactDetailsFromJson(Map<String, dynamic> json) {
  return ContactDetails(
    email: json['email'] as String?,
    phone: json['phone'] as String?,
  );
}

Map<String, dynamic> _$ContactDetailsToJson(ContactDetails instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
    };

Social _$SocialFromJson(Map<String, dynamic> json) {
  return Social(
    facebook: json['facebook'] as String?,
    instagram: json['instagram'] as String?,
    twitter: json['twitter'] as String?,
    youtube: json['youtube'] as String?,
  );
}

Map<String, dynamic> _$SocialToJson(Social instance) => <String, dynamic>{
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'twitter': instance.twitter,
      'youtube': instance.youtube,
    };
