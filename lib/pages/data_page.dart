import 'package:flutter/material.dart';
import '../utils/translations.dart';

class DataPage extends StatefulWidget {
  final String currentLanguage;
  const DataPage({super.key, required this.currentLanguage});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final Map<String, int> _powerMap = {
    'bit': -3,
    'byte': 0,
    'kilobyte': 1,
    'megabyte': 2,
    'gigabyte': 3,
    'terabyte': 4,
    'petabyte': 5,
    'exabyte': 6,
    'zettabyte': 7,
    'yottabyte': 8,
  };

  String? _fromUnit;
  String? _toUnit;
  String _convertedValue = '';
  bool _hasCalculated = false;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fromUnit = 'byte';
    _toUnit = 'kilobyte';
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _inputController.clear();
      _convertedValue = '';
      _fromUnit = 'byte';
      _toUnit = 'kilobyte';
      _hasCalculated = false;
    });
  }

  void _clearResults() {
    setState(() {
      _convertedValue = '';
      _hasCalculated = false;
    });
  }

  String _formatNumber(double number) {
    if (number == 0) return '0';

    if (number.abs() < 0.000001 || number.abs() > 999999999999) {
      return number.toStringAsExponential(6);
    }

    return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 6);
  }

  void _convertUnits() {
    double? inputValue = double.tryParse(_inputController.text);
    if (inputValue == null || inputValue < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please enter a valid positive number')),
        ),
      );
      return;
    }

    if (_fromUnit == null || _toUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please select both units')),
        ),
      );
      return;
    }

    try {
      // Convert to bytes first
      double inBytes;
      if (_fromUnit == 'bit') {
        inBytes = inputValue / 8;
      } else {
        inBytes = inputValue * pow(1024, _powerMap[_fromUnit]!);
      }

      // Convert from bytes to target unit
      double result;
      if (_toUnit == 'bit') {
        result = inBytes * 8;
      } else {
        result = inBytes / pow(1024, _powerMap[_toUnit]!);
      }

      setState(() {
        _convertedValue = _formatNumber(result);
        _hasCalculated = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Conversion error occurred')),
        ),
      );
      _convertedValue = '';
      _hasCalculated = false;
    }
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
                  Icons.storage,
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
              items:
                  _powerMap.keys.map<DropdownMenuItem<String>>((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
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
              items:
                  _powerMap.keys.map<DropdownMenuItem<String>>((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
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
                    _convertedValue,
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
        title: Text(
            Translations.getTranslation(widget.currentLanguage, 'data_unit')),
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

  num pow(num x, int exponent) {
    num result = 1;
    for (int i = 0; i < exponent.abs(); i++) {
      result *= x;
    }
    return exponent < 0 ? 1 / result : result;
  }
}
