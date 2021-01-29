class WeightConverter {

  static double poundsAndOuncesToGrams({int pounds, int ounces}) {
    final int totalOunces = _poundsToOunces(pounds: pounds) + ounces;
    return _ouncesToGrams(ounces: totalOunces);
  }

  static String gramsToPoundsAndOunces(double grams) {
    double ounces = _gramsToOunces(grams);
    int pounds = (ounces / 16).floor();
    int relativeOunces = (ounces % 16).floor();
    return "$pounds Ibs, $relativeOunces oz";
  }

  static String gramsToPoundsWhole(double grams) {
    double ounces = _gramsToOunces(grams);
    int pounds = (ounces / 16).floor();
    return "$pounds Ibs";
  }

  static int _poundsToOunces({int pounds}) {
    return pounds * 16;
  }

  static double _ouncesToGrams({int ounces}) {
    return ounces * 28.34952;
  }
  static double _gramsToOunces(double grams) {
    return grams / 28.34952;
  }

}