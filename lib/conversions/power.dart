class Power {
  final double value;
  final String unit;

  static const Map<String, double> _conversionRates = {
    'W': 1.0,
    'kW': 1000.0,
    'hp': 745.7,
    'J/s': 1.0,
  };

  Power(this.value, this.unit);

  double valueIn(String targetUnit) {
    if (!_conversionRates.containsKey(unit) || !_conversionRates.containsKey(targetUnit)) {
      throw Exception('Unsupported unit');
    }
    double baseValue = value * _conversionRates[unit]!;
    return baseValue / _conversionRates[targetUnit]!;
  }
}
