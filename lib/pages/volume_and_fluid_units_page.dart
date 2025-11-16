import 'package:flutter/material.dart';
import '../utils/translations.dart';

class VolumeAndFluidUnitsPage extends StatefulWidget {
  final String currentLanguage;
  const VolumeAndFluidUnitsPage({super.key, required this.currentLanguage});

  @override
  _VolumeAndFluidUnitsPageState createState() =>
      _VolumeAndFluidUnitsPageState();
}

class _VolumeAndFluidUnitsPageState extends State<VolumeAndFluidUnitsPage> {
  final TextEditingController _inputController = TextEditingController();
  String? _fromUnit;
  String? _toUnit;
  double _convertedValue = 0;
  bool _hasCalculated = false;

  final Map<String, double> _conversionFactors = {
    'Milliliters (mL)': 1,
    'Liters (L)': 1000,
    'Cubic Centimeters (cc)': 1,
    'Cubic Meters (m³)': 1000000,
    'US Fluid Ounces (fl oz)': 29.5735,
    'US Cups': 236.588,
    'US Pints (pt)': 473.176,
    'US Quarts (qt)': 946.353,
    'US Gallons (gal)': 3785.41,
    'Imperial Fluid Ounces (fl oz)': 28.4131,
    'Imperial Cups': 284.131,
    'Imperial Pints (pt)': 568.261,
    'Imperial Quarts (qt)': 1136.52,
    'Imperial Gallons (gal)': 4546.09,
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
      final inMilliliters = inputValue * _conversionFactors[_fromUnit]!;
      _convertedValue = inMilliliters / _conversionFactors[_toUnit]!;
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
                  Icons.water_drop,
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
          Translations.getTranslation(
              widget.currentLanguage, 'volume_and_fluid_units_title'),
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
