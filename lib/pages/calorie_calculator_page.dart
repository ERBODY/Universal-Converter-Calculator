import 'package:flutter/material.dart';
import '../utils/translations.dart';

class CalorieCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const CalorieCalculatorPage({super.key, required this.currentLanguage});

  @override
  _CalorieCalculatorPageState createState() => _CalorieCalculatorPageState();
}

class _CalorieCalculatorPageState extends State<CalorieCalculatorPage> {
  double _weight = 0;
  double _height = 0;
  int _age = 0;
  String _gender = 'Male';
  double _bodyFat = 0;
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  int _feet = 0;
  int _inches = 0;
  String _activityLevel = 'Little or no exercise';
  String _formula = 'Mifflin St Jeor';
  Map<String, double> _results = {};
  bool _showWeightLossInfo = false;
  bool _showWeightGainInfo = false;
  bool _hasCalculated = false;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bodyFatController = TextEditingController();

  final Map<String, double> _activityMultipliers = {
    'Little or no exercise': 1.2,
    'Exercise 1-3 times/week': 1.375,
    'Exercise 4-5 times/week': 1.465,
    'Daily exercise or intense exercise 3-4 times/week': 1.55,
    'Intense exercise 6-7 times/week': 1.725,
    'Very intense exercise daily, or physical job': 1.9
  };

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _ageController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  // Convert weight to kg
  double _getWeightInKg() {
    return _weightUnit == 'kg' ? _weight : _weight * 0.45359237;
  }

  // Convert height to cm
  double _getHeightInCm() {
    if (_heightUnit == 'cm') {
      return _height;
    } else {
      return (_feet * 30.48) + (_inches * 2.54);
    }
  }

  double _calculateMifflinStJeor() {
    double bmr;
    double weightKg = _getWeightInKg();
    double heightCm = _getHeightInCm();

    if (_gender == 'Male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * _age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * _age) - 161;
    }
    return bmr;
  }

  double _calculateRevisedHarrisBenedict() {
    double bmr;
    double weightKg = _getWeightInKg();
    double heightCm = _getHeightInCm();

    if (_gender == 'Male') {
      bmr = (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * _age) + 88.362;
    } else {
      bmr = (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * _age) + 447.593;
    }
    return bmr;
  }

  double _calculateKatchMcArdle() {
    if (_bodyFat <= 0) return 0;
    double weightKg = _getWeightInKg();
    double leanBodyMass = weightKg * (1 - (_bodyFat / 100));
    return 370 + (21.6 * leanBodyMass);
  }

  void _calculateCalories() {
    if (_weight <= 0 ||
        (_heightUnit == 'cm' && _height <= 0) ||
        (_heightUnit == 'ft/in' && (_feet <= 0 && _inches <= 0)) ||
        _age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please fill in all required fields')),
        ),
      );
      setState(() {
        _results = {};
      });
      return;
    }

    double bmr = 0;
    switch (_formula) {
      case 'Mifflin St Jeor':
        bmr = _calculateMifflinStJeor();
        break;
      case 'Revised Harris-Benedict':
        bmr = _calculateRevisedHarrisBenedict();
        break;
      case 'Katch-McArdle Body Fat':
        if (_bodyFat <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Translations.getTranslation(
                  widget.currentLanguage, 'Please enter body fat percentage')),
            ),
          );
          return;
        }
        bmr = _calculateKatchMcArdle();
        break;
    }

    setState(() {
      _results = {
        'BMR': bmr,
        'Daily Calories': bmr * _activityMultipliers[_activityLevel]!,
        'Weight Loss (Mild)': bmr * _activityMultipliers[_activityLevel]! * 0.9,
        'Weight Loss (Moderate)':
            bmr * _activityMultipliers[_activityLevel]! * 0.8,
        'Weight Loss (Extreme)':
            bmr * _activityMultipliers[_activityLevel]! * 0.6,
        'Weight Gain (Mild)': bmr * _activityMultipliers[_activityLevel]! * 1.1,
        'Weight Gain (Moderate)':
            bmr * _activityMultipliers[_activityLevel]! * 1.2,
        'Weight Gain (Extreme)':
            bmr * _activityMultipliers[_activityLevel]! * 1.4,
      };
      _hasCalculated = true;
    });
  }

  Widget _buildHeightInput() {
    if (_heightUnit == 'cm') {
      return TextField(
        controller: _heightController,
        decoration: InputDecoration(
          labelText:
              Translations.getTranslation(widget.currentLanguage, 'Height'),
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          setState(() {
            _height = double.tryParse(value) ?? 0;
          });
        },
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _feetController,
              decoration: InputDecoration(
                labelText:
                    Translations.getTranslation(widget.currentLanguage, 'Feet'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _feet = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _inchesController,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'Inches'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _inches = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
        ],
      );
    }
  }

  String _formatWeight(double kg) {
    if (_weightUnit == 'kg') {
      return '${kg.toStringAsFixed(2)}kg';
    } else {
      return '${(kg * 2.20462).toStringAsFixed(2)}lb';
    }
  }

  Widget _buildWeightLossInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showWeightLossInfo ? null : 0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Weight Loss Goals:'),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildGoalRow(
                'Mild weight loss',
                0.25,
                _results['Daily Calories']! - 250,
                Colors.blue.shade200,
              ),
              const SizedBox(height: 12),
              _buildGoalRow(
                'Weight loss',
                0.5,
                _results['Daily Calories']! - 500,
                Colors.blue.shade400,
              ),
              const SizedBox(height: 12),
              _buildGoalRow(
                'Extreme weight loss',
                1.0,
                _results['Daily Calories']! - 1000,
                Colors.blue.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightGainInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showWeightGainInfo ? null : 0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Weight Gain Goals:'),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildGoalRow(
                'Mild weight gain',
                0.25,
                _results['Daily Calories']! + 250,
                Colors.green.shade200,
              ),
              const SizedBox(height: 12),
              _buildGoalRow(
                'Weight gain',
                0.5,
                _results['Daily Calories']! + 500,
                Colors.green.shade400,
              ),
              const SizedBox(height: 12),
              _buildGoalRow(
                'Fast weight gain',
                1.0,
                _results['Daily Calories']! + 1000,
                Colors.green.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalRow(
      String label, double weight, double calories, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Translations.getTranslation(widget.currentLanguage, label)}: ${_formatWeight(weight)}/week',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            '${Translations.getTranslation(widget.currentLanguage, 'Calories')}: ${calories.toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translations.getTranslation(widget.currentLanguage, title),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'Calorie Calculator')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _weightController.clear();
                _heightController.clear();
                _feetController.clear();
                _inchesController.clear();
                _ageController.clear();
                _bodyFatController.clear();
                _weight = 0;
                _height = 0;
                _feet = 0;
                _inches = 0;
                _age = 0;
                _bodyFat = 0;
                _results = {};
                _showWeightLossInfo = false;
                _showWeightGainInfo = false;
                _hasCalculated = false;
              });
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputSection(
                      'Weight',
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _weightController,
                              decoration: InputDecoration(
                                labelText: Translations.getTranslation(
                                    widget.currentLanguage, 'Weight'),
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (value) {
                                setState(() {
                                  _weight = double.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          DropdownButton<String>(
                            value: _weightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                _weightUnit = newValue!;
                              });
                            },
                            items: <String>['kg', 'lb']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    _buildInputSection(
                      'Height',
                      Row(
                        children: [
                          Expanded(child: _buildHeightInput()),
                          const SizedBox(width: 16),
                          DropdownButton<String>(
                            value: _heightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                _heightUnit = newValue!;
                                _heightController.clear();
                                _feetController.clear();
                                _inchesController.clear();
                                _height = 0;
                                _feet = 0;
                                _inches = 0;
                              });
                            },
                            items: <String>['cm', 'ft/in']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    _buildInputSection(
                      'Age',
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: Translations.getTranslation(
                              widget.currentLanguage, 'Your age'),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _age = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    _buildInputSection(
                      'Gender',
                      DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _gender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female']
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
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputSection(
                      'Activity Level',
                      DropdownButtonFormField<String>(
                        value: _activityLevel,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _activityLevel = newValue!;
                          });
                        },
                        items: _activityMultipliers.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    _buildInputSection(
                      'BMR Formula',
                      DropdownButtonFormField<String>(
                        value: _formula,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _formula = newValue!;
                            if (_formula != 'Katch-McArdle Body Fat') {
                              _bodyFat = 0;
                              _bodyFatController.clear();
                            }
                          });
                        },
                        items: <String>[
                          'Mifflin St Jeor',
                          'Revised Harris-Benedict',
                          'Katch-McArdle Body Fat'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_formula == 'Katch-McArdle Body Fat')
                      _buildInputSection(
                        'Body Fat Percentage',
                        TextField(
                          controller: _bodyFatController,
                          decoration: InputDecoration(
                            labelText: Translations.getTranslation(
                                widget.currentLanguage, 'Body Fat %'),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          onChanged: (value) {
                            setState(() {
                              _bodyFat = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateCalories,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Calculate Calories'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            if (_hasCalculated && _results.isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translations.getTranslation(
                            widget.currentLanguage, 'Results'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${Translations.getTranslation(widget.currentLanguage, 'BMR')}: ${_results['BMR']?.toStringAsFixed(0)} calories',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${Translations.getTranslation(widget.currentLanguage, 'Daily Calories')}: ${_results['Daily Calories']?.toStringAsFixed(0)} calories',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showWeightLossInfo = !_showWeightLossInfo;
                                  if (_showWeightLossInfo) {
                                    _showWeightGainInfo = false;
                                  }
                                });
                              },
                              icon: Icon(_showWeightLossInfo
                                  ? Icons.remove
                                  : Icons.add),
                              label: Text(
                                Translations.getTranslation(
                                  widget.currentLanguage,
                                  _showWeightLossInfo
                                      ? 'Hide weight loss info'
                                      : 'Weight loss info',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showWeightGainInfo = !_showWeightGainInfo;
                                  if (_showWeightGainInfo) {
                                    _showWeightLossInfo = false;
                                  }
                                });
                              },
                              icon: Icon(_showWeightGainInfo
                                  ? Icons.remove
                                  : Icons.add),
                              label: Text(
                                Translations.getTranslation(
                                  widget.currentLanguage,
                                  _showWeightGainInfo
                                      ? 'Hide weight gain info'
                                      : 'Weight gain info',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildWeightLossInfo(),
              _buildWeightGainInfo(),
            ],
          ],
        ),
      ),
    );
  }
}
