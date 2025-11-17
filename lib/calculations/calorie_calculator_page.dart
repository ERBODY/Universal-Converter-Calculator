import 'package:flutter/material.dart';
import '../widgets/standardized_components.dart';

class CalorieCalculatorPage extends StatefulWidget {
  const CalorieCalculatorPage({super.key});

  @override
  State<CalorieCalculatorPage> createState() => _CalorieCalculatorPageState();
}

class _CalorieCalculatorPageState extends State<CalorieCalculatorPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _activityLevel = 'Sedentary';
  String _result = '';

  void _calculateCalories() {
    double height = double.tryParse(_heightController.text) ?? 0.0;
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    int age = int.tryParse(_ageController.text) ?? 0;

    // Input validation
    if (height <= 0 || weight <= 0 || age <= 0) {
      showStandardError(context, 'Invalid Input', 'Please enter valid positive values for all fields');
      return;
    }

    double bmr;

    // Basic BMR calculation using Mifflin-St Jeor Equation (assuming male for simplicity)
    bmr = 10 * weight + 6.25 * height - 5 * age + 5;

    double activityMultiplier;
    switch (_activityLevel) {
      case 'Sedentary':
        activityMultiplier = 1.2;
        break;
      case 'Lightly active':
        activityMultiplier = 1.375;
        break;
      case 'Moderately active':
        activityMultiplier = 1.55;
        break;
      case 'Very active':
        activityMultiplier = 1.725;
        break;
      default:
        activityMultiplier = 1.0;
    }

    double dailyCalories = bmr * activityMultiplier;

    setState(() {
      _result = dailyCalories.toStringAsFixed(0);
    });
  }

  void _clearAll() {
    setState(() {
      _heightController.clear();
      _weightController.clear();
      _ageController.clear();
      _activityLevel = 'Sedentary';
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Calorie Calculator',
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  StandardInputField(
                    controller: _heightController,
                    labelText: 'Height',
                    hintText: 'Enter height in cm',
                    prefixIcon: Icons.height,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      }
                      final height = double.tryParse(value);
                      if (height == null || height <= 0) {
                        return 'Please enter a valid height';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  StandardInputField(
                    controller: _weightController,
                    labelText: 'Weight',
                    hintText: 'Enter weight in kg',
                    prefixIcon: Icons.monitor_weight,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  StandardInputField(
                    controller: _ageController,
                    labelText: 'Age',
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
            AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity Level',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StandardDropdown<String>(
                    value: _activityLevel,
                    labelText: 'Select your activity level',
                    hintText: 'Choose activity level',
                    items: <String>['Sedentary', 'Lightly active', 'Moderately active', 'Very active']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _activityLevel = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sedentary: Little or no exercise\nLightly active: Light exercise/sports 1-3 days/week\nModerately active: Moderate exercise/sports 3-5 days/week\nVery active: Hard exercise/sports 6-7 days a week',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              text: 'Calculate Daily Calories',
              icon: Icons.calculate,
              onPressed: _calculateCalories,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultCard(
                title: 'Daily Calorie Needs',
                result: _result,
                unit: 'calories',
                icon: Icons.local_fire_department,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
