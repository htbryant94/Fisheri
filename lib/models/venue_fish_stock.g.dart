// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_fish_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueFishStock _$VenueFishStockFromJson(Map<String, dynamic> json) {
  return VenueFishStock(
    (json['with_weight'] as List<dynamic>)
        .map((e) => FishWithWeight.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['brownTrout'] as bool,
    json['chub'] as bool,
    json['crucian_carp'] as bool,
    json['dace'] as bool,
    json['eel'] as bool,
    json['grassCarp'] as bool,
    json['grayling'] as bool,
    json['gudgeon'] as bool,
    json['koiCarp'] as bool,
    json['orfe'] as bool,
    json['perch'] as bool,
    json['rainbowTrout'] as bool,
    json['roach'] as bool,
    json['rudd'] as bool,
    json['ruffe'] as bool,
    json['salmon'] as bool,
    json['zander'] as bool,
  );
}

Map<String, dynamic> _$VenueFishStockToJson(VenueFishStock instance) =>
    <String, dynamic>{
      'with_weight': instance.withWeight,
      'brownTrout': instance.brownTrout,
      'chub': instance.chub,
      'crucian_carp': instance.crucianCarp,
      'dace': instance.dace,
      'eel': instance.eel,
      'grassCarp': instance.grassCarp,
      'grayling': instance.grayling,
      'gudgeon': instance.gudgeon,
      'koiCarp': instance.koiCarp,
      'orfe': instance.orfe,
      'perch': instance.perch,
      'rainbowTrout': instance.rainbowTrout,
      'roach': instance.roach,
      'rudd': instance.rudd,
      'ruffe': instance.ruffe,
      'salmon': instance.salmon,
      'zander': instance.zander,
    };

FishWithWeight _$FishWithWeightFromJson(Map<String, dynamic> json) {
  return FishWithWeight(
    json['name'] as String,
    json['max_weight'] as int,
    json['is_stocked'] as bool,
  );
}

Map<String, dynamic> _$FishWithWeightToJson(FishWithWeight instance) =>
    <String, dynamic>{
      'name': instance.name,
      'max_weight': instance.maxWeight,
      'is_stocked': instance.isStocked,
    };
