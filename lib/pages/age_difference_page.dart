import 'package:flutter/material.dart';
import '../utils/translations.dart';
import 'package:intl/intl.dart';

class AgeDifferencePage extends StatefulWidget {
  final String currentLanguage;
  const AgeDifferencePage({super.key, required this.currentLanguage});

  @override
  _AgeDifferencePageState createState() => _AgeDifferencePageState();
}

class _AgeDifferencePageState extends State<AgeDifferencePage> {
  DateTime? _firstDate;
  DateTime? _secondDate;
  Map<String, int>? _ageDifference;
  bool _hasCalculated = false;

  void _resetCalculator() {
    setState(() {
      _firstDate = null;
      _secondDate = null;
      _ageDifference = null;
      _hasCalculated = false;
    });
  }

  Future<void> _selectFirstDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _firstDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _firstDate) {
      setState(() {
        _firstDate = picked;
        _calculateAgeDifference();
      });
    }
  }

  Future<void> _selectSecondDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _secondDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _secondDate) {
      setState(() {
        _secondDate = picked;
        _calculateAgeDifference();
      });
    }
  }

  void _calculateAgeDifference() {
    if (_firstDate == null || _secondDate == null) return;

    final difference = _secondDate!.difference(_firstDate!);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    final days = (difference.inDays % 365) % 30;

    setState(() {
      _ageDifference = {
        'years': years,
        'months': months,
        'days': days,
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
                  Icons.calendar_today,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Select Dates'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                Translations.getTranslation(widget.currentLanguage, 'First Date'),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                _firstDate != null
                    ? DateFormat('MMMM d, yyyy').format(_firstDate!)
                    : Translations.getTranslation(
                        widget.currentLanguage, 'No date selected'),
                style: TextStyle(
                  color: _firstDate != null
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              onTap: () => _selectFirstDate(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.person,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                Translations.getTranslation(widget.currentLanguage, 'Second Date'),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                _secondDate != null
                    ? DateFormat('MMMM d, yyyy').format(_secondDate!)
                    : Translations.getTranslation(
                        widget.currentLanguage, 'No date selected'),
                style: TextStyle(
                  color: _secondDate != null
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              onTap: () => _selectSecondDate(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
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
                  Icons.calculate,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Age Difference'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDifferenceUnit(
                    _ageDifference!['years']!,
                    Translations.getTranslation(widget.currentLanguage, 'Years'),
                  ),
                  const SizedBox(height: 8),
                  _buildDifferenceUnit(
                    _ageDifference!['months']!,
                    Translations.getTranslation(widget.currentLanguage, 'Months'),
                  ),
                  const SizedBox(height: 8),
                  _buildDifferenceUnit(
                    _ageDifference!['days']!,
                    Translations.getTranslation(widget.currentLanguage, 'Days'),
                  ),
                ],
              ),
            ),
            if (_firstDate != null && _secondDate != null) ...[
              const SizedBox(height: 16),
              Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
              const SizedBox(height: 8),
              Text(
                '${Translations.getTranslation(widget.currentLanguage, 'First Date')}: ${DateFormat('MMMM d, yyyy').format(_firstDate!)}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${Translations.getTranslation(widget.currentLanguage, 'Second Date')}: ${DateFormat('MMMM d, yyyy').format(_secondDate!)}',
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

  Widget _buildDifferenceUnit(int value, String label) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface,
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
          Translations.getTranslation(widget.currentLanguage, 'Age Difference'),
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
              _buildInputCard(),
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }
}
