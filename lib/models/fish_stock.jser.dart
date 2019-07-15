// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish_stock.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$VenueFishStockJSONSerializer
    implements Serializer<VenueFishStock> {
  Serializer<FishWithWeight> __fishWithWeightJSONSerializer;
  Serializer<FishWithWeight> get _fishWithWeightJSONSerializer =>
      __fishWithWeightJSONSerializer ??= FishWithWeightJSONSerializer();
  @override
  Map<String, dynamic> toMap(VenueFishStock model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'with_weight',
        codeIterable(
            model.withWeight,
            (val) =>
                _fishWithWeightJSONSerializer.toMap(val as FishWithWeight)));
    setMapValue(ret, 'brownTrout', model.brownTrout);
    setMapValue(ret, 'chub', model.chub);
    setMapValue(ret, 'crucian_carp', model.crucianCarp);
    setMapValue(ret, 'dace', model.dace);
    setMapValue(ret, 'eel', model.eel);
    setMapValue(ret, 'grassCarp', model.grassCarp);
    setMapValue(ret, 'grayling', model.grayling);
    setMapValue(ret, 'gudgeon', model.gudgeon);
    setMapValue(ret, 'koiCarp', model.koiCarp);
    setMapValue(ret, 'orfe', model.orfe);
    setMapValue(ret, 'perch', model.perch);
    setMapValue(ret, 'rainbowTrout', model.rainbowTrout);
    setMapValue(ret, 'roach', model.roach);
    setMapValue(ret, 'rudd', model.rudd);
    setMapValue(ret, 'ruffe', model.ruffe);
    setMapValue(ret, 'salmon', model.salmon);
    setMapValue(ret, 'zander', model.zander);
    return ret;
  }

  @override
  VenueFishStock fromMap(Map map) {
    if (map == null) return null;
    final obj = VenueFishStock(
        getJserDefault('withWeight'),
        getJserDefault('brownTrout'),
        getJserDefault('chub'),
        getJserDefault('crucianCarp'),
        getJserDefault('dace'),
        getJserDefault('eel'),
        getJserDefault('grassCarp'),
        getJserDefault('grayling'),
        getJserDefault('gudgeon'),
        getJserDefault('koiCarp'),
        getJserDefault('orfe'),
        getJserDefault('perch'),
        getJserDefault('rainbowTrout'),
        getJserDefault('roach'),
        getJserDefault('rudd'),
        getJserDefault('ruffe'),
        getJserDefault('salmon'),
        getJserDefault('zander'));
    obj.withWeight = codeIterable<FishWithWeight>(
        map['with_weight'] as Iterable,
        (val) => _fishWithWeightJSONSerializer.fromMap(val as Map));
    obj.brownTrout = map['brownTrout'] as bool;
    obj.chub = map['chub'] as bool;
    obj.crucianCarp = map['crucian_carp'] as bool;
    obj.dace = map['dace'] as bool;
    obj.eel = map['eel'] as bool;
    obj.grassCarp = map['grassCarp'] as bool;
    obj.grayling = map['grayling'] as bool;
    obj.gudgeon = map['gudgeon'] as bool;
    obj.koiCarp = map['koiCarp'] as bool;
    obj.orfe = map['orfe'] as bool;
    obj.perch = map['perch'] as bool;
    obj.rainbowTrout = map['rainbowTrout'] as bool;
    obj.roach = map['roach'] as bool;
    obj.rudd = map['rudd'] as bool;
    obj.ruffe = map['ruffe'] as bool;
    obj.salmon = map['salmon'] as bool;
    obj.zander = map['zander'] as bool;
    return obj;
  }
}

abstract class _$FishWithWeightJSONSerializer
    implements Serializer<FishWithWeight> {
  @override
  Map<String, dynamic> toMap(FishWithWeight model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'max_weight', model.maxWeight);
    setMapValue(ret, 'is_stocked', model.isStocked);
    return ret;
  }

  @override
  FishWithWeight fromMap(Map map) {
    if (map == null) return null;
    final obj = FishWithWeight(getJserDefault('name'),
        getJserDefault('maxWeight'), getJserDefault('isStocked'));
    obj.name = map['name'] as String;
    obj.maxWeight = map['max_weight'] as int;
    obj.isStocked = map['is_stocked'] as bool;
    return obj;
  }
}
