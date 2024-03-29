import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:json_annotation/json_annotation.dart';
part 'venue_detailed.g.dart';

@JsonSerializable(explicitToJson: true)
class VenueDetailed {
  VenueDetailed({
    required this.id,
    this.address,
    this.alwaysOpen,
    this.amenities,
    this.categories,
    this.contactDetails,
    this.coordinates,
    this.description,
    this.fishingRules,
    this.fishStock,
    this.fishStocked,
    this.fishingTackles,
    this.fishingTypes,
    this.images,
    this.name,
    this.numberOfLakes,
    this.operationalHours,
    this.social,
    this.tickets,
    this.websiteURL,
  });

  String id;
  VenueAddress? address;

  @JsonKey(name: 'always_open')
  bool? alwaysOpen;

  List<String>? amenities;
  List<String>? categories;

  @JsonKey(name: 'contact_details')
  ContactDetails? contactDetails;

  @JsonKey(name: 'coordinates', fromJson: _fromJsonGeoPoint, toJson: _toJsonGeoPoint)
  GeoPoint? coordinates;

  String? description;

  @JsonKey(name: 'fishing_rules')
  String? fishingRules;

  @JsonKey(name: 'fish_stock')
  List<FishStock>? fishStock;

  @JsonKey(name: 'fish_stock_array')
  List<String>? fishStocked;

  @JsonKey(name: 'fishing_tackles')
  List<String>? fishingTackles;

  @JsonKey(name: 'fishing_types')
  List<String>? fishingTypes;

  List<String?>? images;
  String? name;

  @JsonKey(name: 'number_of_lakes')
  int? numberOfLakes;

  @JsonKey(name: 'hours_of_operation')
  HoursOfOperation? operationalHours;

  Social? social;
  List<String>? tickets;

  @JsonKey(name: 'website_url')
  String? websiteURL;
  factory VenueDetailed.fromJson(Map<String, dynamic> json) => _$VenueDetailedFromJson(json);
  Map<String, dynamic> toJson() => _$VenueDetailedToJson(this);

  // GeoPoint
  static GeoPoint? _fromJsonGeoPoint(GeoPoint? geoPoint) { return geoPoint; }
  static Map<String, dynamic>? _toJsonGeoPoint(GeoPoint? geoPoint) {
    if (geoPoint != null) {
      return {'latitude': geoPoint.latitude, 'longitude': geoPoint.longitude};
    }
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class FishStock {
  FishStock({
    this.name,
    this.weight,
});

  String? name;
  int? weight;
  late int priority;

  factory FishStock.fromJson(Map<String, dynamic> json) => _$FishStockFromJson(json);
  Map<String, dynamic> toJson() => _$FishStockToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ContactDetails {
  ContactDetails({
    this.email,
    this.phone,
  });

  String? email;
  String? phone;

  factory ContactDetails.fromJson(Map<String, dynamic> json) => _$ContactDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ContactDetailsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Social {
  Social({
    this.facebook,
    this.instagram,
    this.twitter,
    this.youtube,
  });

  String? facebook;
  String? instagram;
  String? twitter;
  String? youtube;

  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}
