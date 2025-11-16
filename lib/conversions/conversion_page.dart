import 'package:flutter/material.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  String _selectedConversion = 'Length';
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  final TextEditingController _valueController = TextEditingController();
  String _result = '';

  final Map<String, List<String>> _units = {
    'Length': ['Meter', 'Kilometer', 'Mile', 'Inch'],
    'Weight': ['Kilogram', 'Gram', 'Ton', 'Pound'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Volume': ['Liter', 'Milliliter', 'Gallon'],
    'Time': ['Second', 'Minute', 'Hour', 'Day'],
  };

  final Map<String, Map<String, double>> _conversionFactors = {
    'Length': {
      'Meter': 1.0,
      'Kilometer': 0.001,
      'Mile': 0.000621371,
      'Inch': 39.3701,
    },
    'Weight': {
      'Kilogram': 1.0,
      'Gram': 1000.0,
      'Ton': 0.001,
      'Pound': 2.20462,
    },
    'Temperature': {},
    'Volume': {
      'Liter': 1.0,
      'Milliliter': 1000.0,
      'Gallon': 0.264172,
    },
    'Time': {
      'Second': 1.0,
      'Minute': 1/60,
      'Hour': 1/3600,
      'Day': 1/86400,
    },
  };

  double _convertTemperature(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;
    double celsiusValue;
    // Convert from input unit to Celsius
    switch (fromUnit) {
      case 'Celsius':
        celsiusValue = value;
        break;
      case 'Fahrenheit':
        celsiusValue = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsiusValue = value - 273.15;
        break;
      default:
        throw Exception('Invalid temperature unit');
    }
    // Convert from Celsius to target unit
    switch (toUnit) {
      case 'Celsius':
        return celsiusValue;
      case 'Fahrenheit':
        return celsiusValue * 9 / 5 + 32;
      case 'Kelvin':
        return celsiusValue + 273.15;
      default:
        throw Exception('Invalid temperature unit');
    }
  }

  void _convert() {
    setState(() {
      double value = double.tryParse(_valueController.text) ?? 0.0;
      if (_selectedConversion == 'Temperature') {
        _result = _convertTemperature(value, _fromUnit, _toUnit).toStringAsFixed(2);
      } else {
        double fromFactor = _conversionFactors[_selectedConversion]![_fromUnit]!;
        double toFactor = _conversionFactors[_selectedConversion]![_toUnit]!;
        double convertedValue = value * (toFactor / fromFactor);
        _result = convertedValue.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedConversion,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConversion = newValue!;
                  _fromUnit = _units[_selectedConversion]![0];
                  _toUnit = _units[_selectedConversion]![1];
                });
              },
              items: _units.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _fromUnit = newValue!;
                      });
                    },
                    items: _units[_selectedConversion]!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _toUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _toUnit = newValue!;
                      });
                    },
                    items: _units[_selectedConversion]!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Enter value',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            Text('Result: $_result'),
          ],
        ),
      ),
    );
  }
}
