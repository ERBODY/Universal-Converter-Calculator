class Energy {
  final double value;
  final String unit;

  static const Map<String, double> _conversionRates = {
    'J': 1.0,
    'kJ': 1000.0,
    'cal': 4.184,
    'kcal': 4184.0,
    'Wh': 3600.0,
  };

  Energy(this.value, this.unit);

  double valueIn(String targetUnit) {
    if (!_conversionRates.containsKey(unit) || !_conversionRates.containsKey(targetUnit)) {
      throw Exception('Unsupported unit');
    }
    double baseValue = value * _conversionRates[unit]!;
    return baseValue / _conversionRates[targetUnit]!;
  }
}
