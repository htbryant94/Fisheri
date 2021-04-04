class WeightConverter {

  static double poundsAndOuncesToGrams({int pounds, int ounces}) {
    final poundsToGrams = _poundsToGrams(pounds);
    final ouncesToGrams = _ouncesToGrams(ounces: ounces);
    return poundsToGrams + ouncesToGrams;
  }

  static String gramsToPoundsAndOunces(double grams) {
    final ounces = _gramsToOunces(grams);
    final pounds = (ounces / 16);
    final fraction = pounds % 1;
    final relativeOunces = fraction * 16;
    return '${pounds.truncate()} Ibs, ${relativeOunces.truncate()} oz';
  }

  static int gramsToPoundsWhole(double grams) {
    final ounces = _gramsToOunces(grams);
    final poundsWhole = (ounces / 16).round();
    return poundsWhole;
  }

  static int _poundsToOunces({int pounds}) {
    return pounds * 16;
  }

  static double _poundsToGrams(int pounds) {
    return pounds * 453.59237;
  }

  static double _ouncesToGrams({int ounces}) {
    return ounces * 28.34952;
  }
  static double _gramsToOunces(double grams) {
    return grams / 28.34952;
  }

}