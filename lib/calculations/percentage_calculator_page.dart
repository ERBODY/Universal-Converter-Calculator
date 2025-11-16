import 'package:flutter/material.dart';

class PercentageCalculatorPage extends StatefulWidget {
  const PercentageCalculatorPage({super.key});

  @override
  State<PercentageCalculatorPage> createState() => _PercentageCalculatorPageState();
}

class _PercentageCalculatorPageState extends State<PercentageCalculatorPage> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  String _calculationType = 'Discount';
  String _result = '';

  void _calculatePercentage() {
    double value = double.tryParse(_valueController.text) ?? 0.0;
    double percentage = double.tryParse(_percentageController.text) ?? 0.0;
    double resultValue;

    switch (_calculationType) {
      case 'Discount':
        resultValue = value - (value * (percentage / 100));
        break;
      case 'Profit':
        resultValue = value + (value * (percentage / 100));
        break;
      default:
        resultValue = 0.0;
    }

    setState(() {
      _result = resultValue.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Percentage Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _calculationType,
              onChanged: (String? newValue) {
                setState(() {
                  _calculationType = newValue!;
                });
              },
              items: <String>['Discount', 'Profit']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Enter value',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _percentageController,
              decoration: const InputDecoration(
                labelText: 'Enter percentage',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculatePercentage,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            Text('Result: $_result'),
          ],
        ),
      ),
    );
  }
}
