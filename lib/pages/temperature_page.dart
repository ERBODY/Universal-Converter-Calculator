import 'package:flutter/material.dart';
import '../utils/translations.dart';

class TemperaturePage extends StatefulWidget {
  final String currentLanguage;
  const TemperaturePage({super.key, required this.currentLanguage});

  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  final List<String> _temperatureUnits = [
    'Celsius',
    'Fahrenheit',
    'Kelvin',
    'Rankine'
  ];
  String? _fromUnit;
  String? _toUnit;
  double _convertedValue = 0;
  bool _hasCalculated = false;
  final TextEditingController _inputController = TextEditingController();

  // Temperature conversion functions
  double _convertTemperature(double value, String from, String to) {
    // First convert to Celsius as base unit
    double celsius;
    switch (from) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      case 'Rankine':
        celsius = (value - 491.67) * 5 / 9;
        break;
      default:
        throw Exception('Unsupported unit');
    }

    // Then convert from Celsius to target unit
    switch (to) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'Kelvin':
        return celsius + 273.15;
      case 'Rankine':
        return (celsius + 273.15) * 9 / 5;
      default:
        throw Exception('Unsupported unit');
    }
  }

  @override
  void initState() {
    super.initState();
    _fromUnit = null;
    _toUnit = null;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _inputController.clear();
      _fromUnit = null;
      _toUnit = null;
      _convertedValue = 0;
      _hasCalculated = false;
    });
  }

  void _clearResults() {
    setState(() {
      _convertedValue = 0;
      _hasCalculated = false;
    });
  }

  void _convertUnits() {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please enter a value to convert.')),
        ),
      );
      return;
    }

    double? inputValue = double.tryParse(_inputController.text);
    if (inputValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(widget.currentLanguage,
              'Invalid input. Please enter a valid number.')),
        ),
      );
      return;
    }

    if (_fromUnit == null || _toUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(widget.currentLanguage,
              'Please select both "From" and "To" units.')),
        ),
      );
      return;
    }

    try {
      _convertedValue = _convertTemperature(inputValue, _fromUnit!, _toUnit!);
      _hasCalculated = true;

      // Handle very small or very large numbers
      if (_convertedValue.abs() < 0.000001 && _convertedValue != 0) {
        _convertedValue = 0;
        _hasCalculated = false;
        throw Exception('Result too small to display');
      }
      if (_convertedValue.abs() > 999999999999999) {
        _convertedValue = 0;
        _hasCalculated = false;
        throw Exception('Result too large to display');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().contains('Exception:')
              ? e.toString().split('Exception: ')[1]
              : 'Conversion from $_fromUnit to $_toUnit is not supported.'),
        ),
      );
      _convertedValue = 0;
      _hasCalculated = false;
    }

    setState(() {});
  }

  Widget _buildInputCard() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.thermostat,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Input'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _inputController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'Enter value'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.input,
                  color: theme.colorScheme.primary,
                ),
              ),
              onChanged: (value) => _clearResults(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _fromUnit,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'From Unit'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.arrow_downward,
                  color: theme.colorScheme.primary,
                ),
              ),
              hint: Text(Translations.getTranslation(
                  widget.currentLanguage, 'Select unit')),
              items: _temperatureUnits
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _fromUnit = value;
                  _clearResults();
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _toUnit,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'To Unit'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.arrow_upward,
                  color: theme.colorScheme.primary,
                ),
              ),
              hint: Text(Translations.getTranslation(
                  widget.currentLanguage, 'Select unit')),
              items: _temperatureUnits
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _toUnit = value;
                  _clearResults();
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _convertUnits,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'calculate'),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (!_hasCalculated) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calculate,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Result'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _convertedValue
                        .toStringAsFixed(_convertedValue.abs() < 0.01 ? 6 : 2),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _toUnit ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
            const SizedBox(height: 8),
            Text(
              '${Translations.getTranslation(widget.currentLanguage, 'Original')}: ${_inputController.text} ${_fromUnit ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'temperature_unit')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
            tooltip:
                Translations.getTranslation(widget.currentLanguage, 'Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }
}
