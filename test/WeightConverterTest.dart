
import 'package:fisheri/WeightConverter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert pounds and ounces to correct grams', () {
    final actual = WeightConverter.poundsAndOuncesToGrams(pounds: 1, ounces: 1);
    expect(actual, 481.94183999999996);
  });

  test('should convert grams to correct pounds and ounces', () {
    final actual = WeightConverter.gramsToPoundsAndOunces(1000);
    expect(actual, "2 Ibs, 3 oz");
  });

}