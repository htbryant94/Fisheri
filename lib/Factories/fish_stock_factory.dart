// @dart=2.9

import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/types/fish_stock_list.dart';
import 'package:flutter/foundation.dart';
import 'package:recase/recase.dart';

class FishStockFactory {
  static FishStock make(FishStockList fishStockList, int weight) {
    return FishStock(
        name: ReCase(describeEnum(fishStockList)).titleCase,
        weight: weight
    );
  }
}