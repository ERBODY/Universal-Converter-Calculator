import 'package:flutter/material.dart';
import '../utils/translations.dart';

class BMICalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const BMICalculatorPage({super.key, required this.currentLanguage});

  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  Map<String, dynamic> _results = {};
  bool _hasCalculated = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _feetController.clear();
      _inchesController.clear();
      _ageController.clear();
      _gender = 'Male';
      _weightUnit = 'kg';
      _heightUnit = 'cm';
      _results = {};
      _hasCalculated = false;
    });
  }

  void _clearResults() {
    setState(() {
      _results = {};
      _hasCalculated = false;
    });
  }

  double _getHeightInCm() {
    if (_heightUnit == 'cm') {
      return double.tryParse(_heightController.text) ?? 0;
    } else {
      int feet = int.tryParse(_feetController.text) ?? 0;
      double inches = double.tryParse(_inchesController.text) ?? 0;
      return (feet * 30.48) + (inches * 2.54);
    }
  }

  double _getWeightInKg() {
    double? weight = double.tryParse(_weightController.text);
    if (weight == null) return 0;
    return _weightUnit == 'kg' ? weight : weight * 0.45359237;
  }

  void _calculateBMI() {
    double heightCm = _getHeightInCm();
    double weightKg = _getWeightInKg();
    int? age = int.tryParse(_ageController.text);

    if (_weightController.text.isEmpty ||
        (_heightUnit == 'cm' && _heightController.text.isEmpty) ||
        (_heightUnit == 'in' &&
            (_feetController.text.isEmpty && _inchesController.text.isEmpty)) ||
        _ageController.text.isEmpty ||
        age == null ||
        age <= 0 ||
        weightKg <= 0 ||
        heightCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(widget.currentLanguage,
              'Please fill all fields with valid values')),
        ),
      );
      setState(() {
        _results = {};
        _hasCalculated = false;
      });
      return;
    }

    double heightM = heightCm / 100;
    double bmi = weightKg / (heightM * heightM);

    double idealWeightLow = 18.5 * heightM * heightM;
    double idealWeightHigh = 24.9 * heightM * heightM;

    if (_weightUnit == 'lb') {
      idealWeightLow = idealWeightLow * 2.20462;
      idealWeightHigh = idealWeightHigh * 2.20462;
    }

    setState(() {
      _results = {
        'bmi': bmi,
        'classification': _classifyBMI(bmi),
        'idealWeightLow': idealWeightLow,
        'idealWeightHigh': idealWeightHigh,
      };
      _hasCalculated = true;
    });
  }

  String _classifyBMI(double bmi) {
    if (bmi < 18.5) {
      return Translations.getTranslation(widget.currentLanguage, 'Underweight');
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return Translations.getTranslation(
          widget.currentLanguage, 'Normal weight');
    } else if (bmi >= 25 && bmi < 29.9) {
      return Translations.getTranslation(widget.currentLanguage, 'Overweight');
    } else {
      return Translations.getTranslation(widget.currentLanguage, 'Obesity');
    }
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 29.9) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildHeightInput() {
    final theme = Theme.of(context);

    if (_heightUnit == 'cm') {
      return TextFormField(
        controller: _heightController,
        decoration: InputDecoration(
          labelText: Translations.getTranslation(
              widget.currentLanguage, 'Height (cm)'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            Icons.height,
            color: theme.colorScheme.primary,
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) => _clearResults(),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _feetController,
              decoration: InputDecoration(
                labelText: 'Feet',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.height,
                  color: theme.colorScheme.primary,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _clearResults(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _inchesController,
              decoration: InputDecoration(
                labelText: 'Inches',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.height,
                  color: theme.colorScheme.primary,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => _clearResults(),
            ),
          ),
        ],
      );
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
                  Icons.fitness_center,
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

            // Gender Selection
            Text(
              Translations.getTranslation(widget.currentLanguage, 'Gender'),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Male'),
                      style: TextStyle(fontSize: 14),
                    ),
                    value: 'Male',
                    groupValue: _gender,
                    activeColor: theme.colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                        _clearResults();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Female'),
                      style: TextStyle(fontSize: 14),
                    ),
                    value: 'Female',
                    groupValue: _gender,
                    activeColor: theme.colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                        _clearResults();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weight Input
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: Translations.getTranslation(
                          widget.currentLanguage, 'Weight'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.monitor_weight,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => _clearResults(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _weightUnit,
                    decoration: InputDecoration(
                      labelText: Translations.getTranslation(
                          widget.currentLanguage, 'Unit'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['kg', 'lb'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _weightUnit = value!;
                        _clearResults();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Height Input
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildHeightInput(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _heightUnit,
                    decoration: InputDecoration(
                      labelText: Translations.getTranslation(
                          widget.currentLanguage, 'Unit'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['cm', 'in'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _heightUnit = value!;
                        _heightController.clear();
                        _feetController.clear();
                        _inchesController.clear();
                        _clearResults();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Age Input
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText:
                    Translations.getTranslation(widget.currentLanguage, 'Age'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.primary,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _clearResults(),
            ),
            const SizedBox(height: 24),

            // Calculate Button
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Calculate BMI'),
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
    final bmi = _results['bmi'] as double;
    final classification = _results['classification'] as String;
    final idealWeightLow = _results['idealWeightLow'] as double;
    final idealWeightHigh = _results['idealWeightHigh'] as double;
    final bmiColor = _getBMIColor(bmi);

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
                  Icons.assessment,
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

            // BMI Value
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bmiColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'BMI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      classification,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ideal Weight Range
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${Translations.getTranslation(widget.currentLanguage, 'Ideal Weight Range')}: ${idealWeightLow.toStringAsFixed(1)} - ${idealWeightHigh.toStringAsFixed(1)} $_weightUnit',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // BMI Scale
            Text(
              Translations.getTranslation(widget.currentLanguage, 'BMI Scale'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildBMIScaleItem(
              Translations.getTranslation(
                  widget.currentLanguage, 'Underweight'),
              '< 18.5',
              Colors.blue,
            ),
            _buildBMIScaleItem(
              Translations.getTranslation(
                  widget.currentLanguage, 'Normal weight'),
              '18.5 - 24.9',
              Colors.green,
            ),
            _buildBMIScaleItem(
              Translations.getTranslation(widget.currentLanguage, 'Overweight'),
              '25 - 29.9',
              Colors.orange,
            ),
            _buildBMIScaleItem(
              Translations.getTranslation(widget.currentLanguage, 'Obesity'),
              '≥ 30',
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIScaleItem(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
          const Spacer(),
          Text(
            range,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'bmi_calculator')),
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
