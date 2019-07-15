import 'package:jaguar_serializer/jaguar_serializer.dart';
part 'fish_stock.jser.dart';

@GenSerializer(
  serializers: const [
    FishWithWeightJSONSerializer
  ],
  fields: const {
  'crucianCarp': EnDecode(alias: 'crucian_carp'),
  'withWeight': EnDecode(alias: 'with_weight')
})
class VenueFishStockJSONSerializer extends Serializer<VenueFishStock>
    with _$VenueFishStockJSONSerializer {}

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

  List<FishWithWeight> withWeight;
  bool brownTrout;
  bool chub;
  bool crucianCarp;
  bool dace;
  bool eel;
  bool grassCarp;
  bool grayling;
  bool gudgeon;
  bool koiCarp;
  bool orfe;
  bool perch;
  bool rainbowTrout;
  bool roach;
  bool rudd;
  bool ruffe;
  bool salmon;
  bool zander;
}

@GenSerializer(fields: const {
  'maxWeight': EnDecode(alias: 'max_weight'),
  'isStocked': EnDecode(alias: 'is_stocked')
})
class FishWithWeightJSONSerializer extends Serializer<FishWithWeight>
    with _$FishWithWeightJSONSerializer {}

class FishWithWeight {
  FishWithWeight(String name, int maxWeight, bool isStocked);

  String name;
  int maxWeight;
  bool isStocked;
}
