import 'package:fisheri/models/venue_address.dart';
import 'package:json_annotation/json_annotation.dart';
part 'venue_search.g.dart';

@JsonSerializable(explicitToJson: true)
class VenueSearch {
  VenueSearch({
    this.id,
    this.address,
    this.alwaysOpen,
    this.amenities,
    this.categories,
    this.fishStocked,
    this.fishingTackles,
    this.fishingTypes,
    this.imageURL,
    this.name,
    this.numberOfLakes,
  });

  String? id;
  VenueAddress? address;

  @JsonKey(name: 'always_open')
  bool? alwaysOpen;

  List<dynamic>? amenities;
  List<dynamic>? categories;

  @JsonKey(name: 'fish_stocked')
  List<dynamic>? fishStocked;

  @JsonKey(name: 'fishing_tackles')
  List<dynamic>? fishingTackles;

  @JsonKey(name: 'fishing_types')
  List<dynamic>? fishingTypes;

  @JsonKey(name: 'image_url')
  String? imageURL;

  String? name;

  @JsonKey(name: 'number_of_lakes')
  int? numberOfLakes;

  factory VenueSearch.fromJson(Map<String, dynamic> json) => _$VenueSearchFromJson(json);
  Map<String, dynamic> toJson() => _$VenueSearchToJson(this);
}