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
    double bmr;

    // Basic BMR calculation using Mifflin-St Jeor Equation
    bmr = 10 * weight + 6.25 * height - 5 * age + 5; // Assuming male for simplicity

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
      _result = dailyCalories.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Enter height (cm)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Enter weight (kg)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Enter age',
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _activityLevel,
              onChanged: (String? newValue) {
                setState(() {
                  _activityLevel = newValue!;
                });
              },
              items: <String>['Sedentary', 'Lightly active', 'Moderately active', 'Very active']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateCalories,
              child: const Text('Calculate Calories'),
            ),
            const SizedBox(height: 20),
            Text('Daily Calories: $_result'),
          ],
        ),
      ),
    );
  }
}
