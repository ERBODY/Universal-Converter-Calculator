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
      return StandardInputField(
        controller: _heightController,
        hintText: 'Enter height in cm',
        prefixIcon: Icons.height,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          setState(() => _results.clear());
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter height';
          }
          final height = double.tryParse(value);
          if (height == null || height <= 0) {
            return 'Please enter a valid height';
          }
          return null;
        },
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: StandardInputField(
              controller: _feetController,
              hintText: 'Feet',
              prefixIcon: Icons.height,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() => _results.clear());
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter feet';
                }
                final feet = int.tryParse(value);
                if (feet == null || feet < 0) {
                  return 'Invalid feet value';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StandardInputField(
              controller: _inchesController,
              hintText: 'Inches',
              prefixIcon: Icons.height,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() => _results.clear());
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter inches';
                }
                final inches = double.tryParse(value);
                if (inches == null || inches < 0 || inches >= 12) {
                  return 'Invalid inches value';
                }
                return null;
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
      appBar: StandardAppBar(
        title: Translations.getTranslation(widget.currentLanguage, 'BMI Calculator'),
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
            // Personal Information Container (Gender + Age)
            AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Gender Selection
                  Text(
                    Translations.getTranslation(widget.currentLanguage, 'Gender'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                          contentPadding: EdgeInsets.zero,
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
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Age Input
                  StandardInputField(
                    controller: _ageController,
                    labelText: Translations.getTranslation(widget.currentLanguage, 'Age'),
                    hintText: 'Enter your age',
                    prefixIcon: Icons.cake,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age <= 0) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            // Body Measurements Container (Weight + Height)
            AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Body Measurements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Weight Input
                  Text(
                    Translations.getTranslation(widget.currentLanguage, 'Weight'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: StandardInputField(
                          controller: _weightController,
                          hintText: 'Enter weight',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            setState(() => _results.clear());
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: StandardDropdown<String>(
                          value: _weightUnit,
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
                  const SizedBox(height: 16),
                  // Height Input
                  Text(
                    Translations.getTranslation(widget.currentLanguage, 'Height'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildHeightInput(),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: StandardDropdown<String>(
                          value: _heightUnit,
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

            const SizedBox(height: 8),

            // Calculate Button
            PrimaryButton(
              text: Translations.getTranslation(widget.currentLanguage, 'Calculate BMI'),
              icon: Icons.calculate,
              onPressed: _calculateBMI,
            ),

            // Results Section
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultCard(
                title: 'BMI Result',
                result: _results['bmi'].toStringAsFixed(1),
                icon: Icons.monitor_heart,
                backgroundColor: _getBMIColor(_results['bmi']).withOpacity(0.1),
                resultStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _getBMIColor(_results['bmi']),
                ),
              ),
              AppContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: _getBMIColor(_results['bmi']),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Classification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getBMIColor(_results['bmi']),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _getBMIColor(_results['bmi']),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _results['classification'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${Translations.getTranslation(widget.currentLanguage, 'Ideal weight range')}: ${_results['idealWeightLow'].toStringAsFixed(1)} - ${_results['idealWeightHigh'].toStringAsFixed(1)} $_weightUnit',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
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
