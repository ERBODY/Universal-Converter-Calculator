// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({super.key});

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  DateTime? _selectedDate;
  String _calendarType = 'Gregorian';
  String _ageResult = '';

  void _calculateAge() {
    if (_selectedDate == null) return;
    final now = DateTime.now();
    int years = now.year - _selectedDate!.year;
    int months = now.month - _selectedDate!.month;
    int days = now.day - _selectedDate!.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    setState(() {
      _ageResult = '$years years, $months months, $days days';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _calendarType,
              onChanged: (String? newValue) {
                setState(() {
                  _calendarType = newValue!;
                });
              },
              items: <String>['Gregorian', 'Hijri']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Birth Date'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAge,
              child: const Text('Calculate Age'),
            ),
            const SizedBox(height: 20),
            Text('Age: $_ageResult'),
          ],
        ),
      ),
    );
  }
}
