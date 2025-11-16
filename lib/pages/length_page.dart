import 'package:flutter/material.dart';
import '../utils/translations.dart';

class LengthPage extends StatefulWidget {
  final String currentLanguage;
  const LengthPage({super.key, required this.currentLanguage});

  @override
  _LengthPageState createState() => _LengthPageState();
}

class _LengthPageState extends State<LengthPage> {
  final TextEditingController _inputController = TextEditingController();
  String? _fromUnit;
  String? _toUnit;
  double _convertedValue = 0;
  bool _hasCalculated = false;

  final Map<String, double> _conversionFactors = {
    'Millimeters (mm)': 1,
    'Centimeters (cm)': 10,
    'Meters (m)': 1000,
    'Kilometers (km)': 1000000,
    'Inches (in)': 25.4,
    'Feet (ft)': 304.8,
    'Yards (yd)': 914.4,
    'Miles (mi)': 1609344,
    'Nautical Miles (nmi)': 1852000,
  };

  void _resetCalculator() {
    setState(() {
      _inputController.clear();
      _fromUnit = null;
      _toUnit = null;
      _convertedValue = 0;
      _hasCalculated = false;
    });
  }

  void _convertUnits() {
    if (_fromUnit == null || _toUnit == null) return;

    final inputValue = double.tryParse(_inputController.text);
    if (inputValue == null) return;

    setState(() {
      final inMillimeters = inputValue * _conversionFactors[_fromUnit]!;
      _convertedValue = inMillimeters / _conversionFactors[_toUnit]!;
      _hasCalculated = true;
    });
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
                  Icons.straighten,
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
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.input,
                  color: theme.colorScheme.primary,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) _convertUnits();
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _fromUnit,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'From Unit'),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.arrow_downward,
                  color: theme.colorScheme.primary,
                ),
              ),
              items: _conversionFactors.keys
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _fromUnit = value;
                  if (_inputController.text.isNotEmpty) _convertUnits();
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _toUnit,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'To Unit'),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.arrow_upward,
                  color: theme.colorScheme.primary,
                ),
              ),
              items: _conversionFactors.keys
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _toUnit = value;
                  if (_inputController.text.isNotEmpty) _convertUnits();
                });
              },
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
                    _convertedValue.toStringAsFixed(4),
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
            if (_fromUnit != null) ...[
              const SizedBox(height: 16),
              Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
              const SizedBox(height: 8),
              Text(
                '${Translations.getTranslation(widget.currentLanguage, 'Original')}: ${_inputController.text} ${_fromUnit!}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'length_unit'),
        ),
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
        child: Padding(
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
      ),
    );
  }
}
