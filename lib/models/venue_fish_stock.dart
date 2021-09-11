import 'package:json_annotation/json_annotation.dart';
part 'venue_fish_stock.g.dart';

@JsonSerializable()
class VenueFishStock {
  VenueFishStock(
      List<FishWithWeight> withWeight,
      bool brownTrout,
      bool chub,
      bool crucianCarp,
      bool dace,
      bool eel,
      bool grassCarp,
      bool grayling,
      bool gudgeon,
      bool koiCarp,
      bool orfe,
      bool perch,
      bool rainbowTrout,
      bool roach,
      bool rudd,
      bool ruffe,
      bool salmon,
      bool zander) {
    this.withWeight = withWeight;
    this.brownTrout = brownTrout;
    this.chub = chub;
    this.crucianCarp = crucianCarp;
    this.dace = dace;
    this.eel = eel;
    this.grassCarp = grassCarp;
    this.grayling = grayling;
    this.gudgeon = gudgeon;
    this.koiCarp = koiCarp;
    this.orfe = orfe;
    this.perch = perch;
    this.rainbowTrout = rainbowTrout;
    this.roach = roach;
    this.rudd = rudd;
    this.ruffe = ruffe;
    this.salmon = salmon;
    this.zander = zander;
  }

  @JsonKey(name: 'with_weight')
  List<FishWithWeight>? withWeight;

  bool? brownTrout;
  bool? chub;

  @JsonKey(name: 'crucian_carp')
  bool? crucianCarp;

  bool? dace;
  bool? eel;
  bool? grassCarp;
  bool? grayling;
  bool? gudgeon;
  bool? koiCarp;
  bool? orfe;
  bool? perch;
  bool? rainbowTrout;
  bool? roach;
  bool? rudd;
  bool? ruffe;
  bool? salmon;
  bool? zander;

  factory VenueFishStock.fromJson(Map<String, dynamic> json) => _$VenueFishStockFromJson(json);
  Map<String, dynamic> toJson() => _$VenueFishStockToJson(this);
}

@JsonSerializable()
class FishWithWeight {
  FishWithWeight(String name, int maxWeight, bool isStocked);

  late String name;

  @JsonKey(name: 'max_weight')
  late int maxWeight;

  @JsonKey(name: 'is_stocked')
  bool? isStocked;

  factory FishWithWeight.fromJson(Map<String, dynamic> json) => _$FishWithWeightFromJson(json);
  Map<String, dynamic> toJson() => _$FishWithWeightToJson(this);
}
