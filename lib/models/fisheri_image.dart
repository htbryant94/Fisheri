import 'package:json_annotation/json_annotation.dart';

part 'fisheri_image.g.dart';

@JsonSerializable(explicitToJson: true)
class FisheriImage {
  FisheriImage({
    required this.id,
    required this.url
  });

  final String id;
  final String url;

  factory FisheriImage.fromJson(Map<String, dynamic> json) => _$FisheriImageFromJson(json);
  Map<String, dynamic> toJson() => _$FisheriImageToJson(this);
}