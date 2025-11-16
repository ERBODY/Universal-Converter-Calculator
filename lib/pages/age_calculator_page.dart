import 'package:flutter/material.dart';
import '../utils/translations.dart';
import 'package:intl/intl.dart';

class AgeCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const AgeCalculatorPage({super.key, required this.currentLanguage});

  @override
  _AgeCalculatorPageState createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  DateTime? _selectedDate;
  int _years = 0;
  int _months = 0;
  int _days = 0;
  bool _hasCalculated = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _hasCalculated = false;
      });
      _calculateAge();
    }
  }

  void _resetCalculator() {
    setState(() {
      _selectedDate = null;
      _years = 0;
      _months = 0;
      _days = 0;
      _hasCalculated = false;
    });
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      final now = DateTime.now();
      int years = now.year - _selectedDate!.year;
      int months = now.month - _selectedDate!.month;
      int days = now.day - _selectedDate!.day;

      // Adjust for negative months or days
      if (days < 0) {
        final lastMonth = DateTime(now.year, now.month - 1, _selectedDate!.day);
        days = now.difference(lastMonth).inDays;
        months--;
      }
      if (months < 0) {
        months += 12;
        years--;
      }

      setState(() {
        _years = years;
        _months = months;
        _days = days;
        _hasCalculated = true;
      });
    }
  }

  Widget _buildDateCard() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Translations.getTranslation(
                        widget.currentLanguage, 'Birth Date'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedDate != null)
                Text(
                  DateFormat('MMMM d, yyyy').format(_selectedDate!),
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                )
              else
                Text(
                  Translations.getTranslation(
                      widget.currentLanguage, 'Select your birth date'),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
            ],
          ),
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
                  Icons.cake,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Your Age'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAgeUnit(
                  _years,
                  Translations.getTranslation(widget.currentLanguage, 'Years'),
                ),
                _buildAgeUnit(
                  _months,
                  Translations.getTranslation(widget.currentLanguage, 'Months'),
                ),
                _buildAgeUnit(
                  _days,
                  Translations.getTranslation(widget.currentLanguage, 'Days'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedDate != null) ...[
              Divider(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
              ),
              const SizedBox(height: 8),
              Text(
                '${Translations.getTranslation(widget.currentLanguage, 'Birth Date')}: ${DateFormat('MMMM d, yyyy').format(_selectedDate!)}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAgeUnit(int value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'Age Calculator'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
            tooltip: Translations.getTranslation(widget.currentLanguage, 'Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDateCard(),
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }
}
