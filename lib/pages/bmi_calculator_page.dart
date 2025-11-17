import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/standardized_components.dart';

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
      setState(() {
        _results = {};
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

  Widget _buildHeightInput() {
    if (_heightUnit == 'cm') {
      return TextField(
        controller: _heightController,
        decoration: InputDecoration(
          hintText: 'enter height',
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          setState(() => _results.clear());
        },
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _feetController,
              decoration: const InputDecoration(
                hintText: 'feet',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() => _results.clear());
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _inchesController,
              decoration: const InputDecoration(
                hintText: 'inches',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() => _results.clear());
              },
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'BMI Calculator')),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _weightController.clear();
                _heightController.clear();
                _feetController.clear();
                _inchesController.clear();
                _ageController.clear();
                _gender = 'Male';
                _weightUnit = 'kg';
                _heightUnit = 'cm';
                _results.clear();
              });
            },
            tooltip: 'Clear',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender Selection Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Gender'),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Male'),
                            value: 'Male',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                                _results.clear();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Female'),
                            value: 'Female',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                                _results.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Weight Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Weight'),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _weightController,
                            decoration: InputDecoration(
                              hintText: 'enter weight',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (value) {
                              setState(() => _results.clear());
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _weightUnit,
                            isExpanded: true,
                            items: ['kg', 'lb'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _weightUnit = value!;
                                _results.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Height Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Height'),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildHeightInput(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _heightUnit,
                            isExpanded: true,
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
                                _results.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Age Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Age'),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        hintText: 'enter age',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() => _results.clear());
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Calculate Button
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Calculate BMI'),
                style: const TextStyle(fontSize: 18),
              ),
            ),

            // Results Section
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${Translations.getTranslation(widget.currentLanguage, 'Your BMI is')} ${_results['bmi'].toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _getBMIColor(_results['bmi']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _results['classification'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${Translations.getTranslation(widget.currentLanguage, 'Ideal weight range')}: ${_results['idealWeightLow'].toStringAsFixed(1)} - ${_results['idealWeightHigh'].toStringAsFixed(1)} $_weightUnit',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue; // Underweight
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return Colors.green; // Normal weight
    } else if (bmi >= 25 && bmi < 29.9) {
      return Colors.orange; // Overweight
    } else {
      return Colors.red; // Obesity
    }
  }
}
