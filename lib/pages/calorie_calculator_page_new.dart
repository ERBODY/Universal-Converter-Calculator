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

  final Map<String, String> _activityLevels = {
    'Little or no exercise': 'Little or no exercise',
    'Light exercise 1-3 days/week': 'Light exercise 1-3 days/week',
    'Moderate exercise 3-5 days/week': 'Moderate exercise 3-5 days/week',
    'Hard exercise 6-7 days/week': 'Hard exercise 6-7 days/week',
    'Very hard exercise & physical job': 'Very hard exercise & physical job',
  };

  final Map<String, double> _activityMultipliers = {
    'Little or no exercise': 1.2,
    'Light exercise 1-3 days/week': 1.375,
    'Moderate exercise 3-5 days/week': 1.55,
    'Hard exercise 6-7 days/week': 1.725,
    'Very hard exercise & physical job': 1.9,
  };

  final List<String> _formulas = [
    'Mifflin St Jeor',
    'Harris-Benedict',
    'Katch-McArdle',
  ];

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

  void _resetCalculator() {
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
      _gender = 'Male';
      _weightUnit = 'kg';
      _heightUnit = 'cm';
      _activityLevel = 'Little or no exercise';
      _formula = 'Mifflin St Jeor';
      _results = {};
      _showWeightLossInfo = false;
      _showWeightGainInfo = false;
      _hasCalculated = false;
    });
  }

  void _clearResults() {
    setState(() {
      _results = {};
      _showWeightLossInfo = false;
      _showWeightGainInfo = false;
      _hasCalculated = false;
    });
  }

  Widget _buildHeightInput() {
    final theme = Theme.of(context);

    if (_heightUnit == 'cm') {
      return TextFormField(
        controller: _heightController,
        decoration: InputDecoration(
          labelText:
              Translations.getTranslation(widget.currentLanguage, 'Height'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            Icons.height,
            color: theme.colorScheme.primary,
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          setState(() {
            _height = double.tryParse(value) ?? 0;
            _clearResults();
          });
        },
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
              onChanged: (value) {
                setState(() {
                  _feet = int.tryParse(value) ?? 0;
                  _height = (_feet * 30.48) + (_inches * 2.54);
                  _clearResults();
                });
              },
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
              onChanged: (value) {
                setState(() {
                  _inches = int.tryParse(value) ?? 0;
                  _height = (_feet * 30.48) + (_inches * 2.54);
                  _clearResults();
                });
              },
            ),
          ),
        ],
      );
    }
  }

  void _calculateCalories() {
    if (_weightController.text.isEmpty ||
        (_heightUnit == 'cm' && _heightController.text.isEmpty) ||
        (_heightUnit == 'in' &&
            (_feetController.text.isEmpty || _inchesController.text.isEmpty)) ||
        _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please fill all required fields')),
        ),
      );
      return;
    }

    if (_formula == 'Katch-McArdle' && _bodyFatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(widget.currentLanguage,
              'Body fat percentage is required for Katch-McArdle formula')),
        ),
      );
      return;
    }

    double bmr = 0;
    double weightKg = _weightUnit == 'kg' ? _weight : _weight * 0.45359237;
    double heightCm = _height;

    if (_formula == 'Mifflin St Jeor') {
      if (_gender == 'Male') {
        bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * _age) + 5;
      } else {
        bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * _age) - 161;
      }
    } else if (_formula == 'Harris-Benedict') {
      if (_gender == 'Male') {
        bmr = 66 + (13.7 * weightKg) + (5 * heightCm) - (6.8 * _age);
      } else {
        bmr = 655 + (9.6 * weightKg) + (1.8 * heightCm) - (4.7 * _age);
      }
    } else if (_formula == 'Katch-McArdle') {
      double leanBodyMass = weightKg * (1 - (_bodyFat / 100));
      bmr = 370 + (21.6 * leanBodyMass);
    }

    double dailyCalories = bmr * _activityMultipliers[_activityLevel]!;

    setState(() {
      _results = {
        'BMR': bmr,
        'Daily Calories': dailyCalories,
        'Weight Loss (Mild)': dailyCalories * 0.9,
        'Weight Loss (Moderate)': dailyCalories * 0.8,
        'Weight Loss (Extreme)': dailyCalories * 0.6,
        'Weight Gain (Mild)': dailyCalories * 1.1,
        'Weight Gain (Moderate)': dailyCalories * 1.2,
        'Weight Gain (Extreme)': dailyCalories * 1.4,
      };
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
                  Icons.local_fire_department,
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
                    onChanged: (value) {
                      setState(() {
                        _weight = double.tryParse(value) ?? 0;
                        _clearResults();
                      });
                    },
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
                        _height = 0;
                        _feet = 0;
                        _inches = 0;
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
              onChanged: (value) {
                setState(() {
                  _age = int.tryParse(value) ?? 0;
                  _clearResults();
                });
              },
            ),
            const SizedBox(height: 16),

            // Body Fat Input (only visible for Katch-McArdle formula)
            if (_formula == 'Katch-McArdle')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _bodyFatController,
                    decoration: InputDecoration(
                      labelText: Translations.getTranslation(
                          widget.currentLanguage, 'Body Fat Percentage (%)'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.percent,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _bodyFat = double.tryParse(value) ?? 0;
                        _clearResults();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Activity Level
            DropdownButtonFormField<String>(
              value: _activityLevel,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'Activity Level'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.directions_run,
                  color: theme.colorScheme.primary,
                ),
              ),
              isExpanded: true,
              items: _activityLevels.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                    Translations.getTranslation(
                        widget.currentLanguage, _activityLevels[key]!),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _activityLevel = newValue!;
                  _clearResults();
                });
              },
            ),
            const SizedBox(height: 16),

            // Formula Selection
            DropdownButtonFormField<String>(
              value: _formula,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'Formula'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.functions,
                  color: theme.colorScheme.primary,
                ),
              ),
              items: _formulas.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _formula = newValue!;
                  _clearResults();
                });
              },
            ),
            const SizedBox(height: 24),

            // Calculate Button
            ElevatedButton(
              onPressed: _calculateCalories,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Calculate'),
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
                  Icons.assessment,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(
                      widget.currentLanguage, 'Results'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // BMR and Daily Calories
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildResultRow(
                    Translations.getTranslation(widget.currentLanguage, 'BMR'),
                    _results['BMR']!.toStringAsFixed(0),
                    'calories/day',
                    Icons.whatshot,
                  ),
                  const SizedBox(height: 12),
                  _buildResultRow(
                    Translations.getTranslation(
                        widget.currentLanguage, 'Daily Calories'),
                    _results['Daily Calories']!.toStringAsFixed(0),
                    'calories/day',
                    Icons.restaurant,
                    isHighlighted: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weight Loss Section
            ListTile(
              title: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Weight Loss'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              trailing: Icon(
                _showWeightLossInfo ? Icons.expand_less : Icons.expand_more,
                color: theme.colorScheme.primary,
              ),
              onTap: () {
                setState(() {
                  _showWeightLossInfo = !_showWeightLossInfo;
                });
              },
            ),
            if (_showWeightLossInfo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildCalorieRow(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Mild (0.25 kg/week)'),
                      _results['Weight Loss (Mild)']!.toStringAsFixed(0),
                      Colors.green.shade300,
                    ),
                    _buildCalorieRow(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Moderate (0.5 kg/week)'),
                      _results['Weight Loss (Moderate)']!.toStringAsFixed(0),
                      Colors.orange.shade300,
                    ),
                    _buildCalorieRow(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Extreme (1 kg/week)'),
                      _results['Weight Loss (Extreme)']!.toStringAsFixed(0),
                      Colors.red.shade300,
                    ),
                  ],
                ),
              ),

            // Weight Gain Section
            ListTile(
              title: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Weight Gain'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              trailing: Icon(
                _showWeightGainInfo ? Icons.expand_less : Icons.expand_more,
                color: theme.colorScheme.primary,
              ),
              onTap: () {
                setState(() {
                  _showWeightGainInfo = !_showWeightGainInfo;
                });
              },
            ),
            if (_showWeightGainInfo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildCalorieRow(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Mild (0.25 kg/week)'),
                      _results['Weight Gain (Mild)']!.toStringAsFixed(0),
                      Colors.green.shade300,
                    ),
                    _buildCalorieRow(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Moderate (0.5 kg/week)'),
                      _results['Weight Gain (Moderate)']!.toStringAsFixed(0),
                      Colors.orange.shade300,
                    ),
                    _buildCalorieRow(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Extreme (1 kg/week)'),
                      _results['Weight Gain (Extreme)']!.toStringAsFixed(0),
                      Colors.red.shade300,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
            const SizedBox(height: 8),
            Text(
              Translations.getTranslation(
                      widget.currentLanguage, 'Formula Used') +
                  ': $_formula',
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

  Widget _buildResultRow(String label, String value, String unit, IconData icon,
      {bool isHighlighted = false}) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          color: isHighlighted
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.7),
          size: isHighlighted ? 24 : 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isHighlighted ? 16 : 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Text(
          '$value $unit',
          style: TextStyle(
            fontSize: isHighlighted ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: isHighlighted
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildCalorieRow(String label, String calories, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            '$calories calories/day',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
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
            widget.currentLanguage, 'calorie_calculator')),
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
