import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/translations.dart';

class DurationCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const DurationCalculatorPage({super.key, required this.currentLanguage});

  @override
  _DurationCalculatorPageState createState() => _DurationCalculatorPageState();
}

class _DurationCalculatorPageState extends State<DurationCalculatorPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _duration = '';
  bool _includeTime = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _duration = '';
      });

      if (_includeTime) {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: _startTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          setState(() {
            _startTime = time;
          });
        }
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _duration = '';
      });

      if (_includeTime) {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: _endTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          setState(() {
            _endTime = time;
          });
        }
      }
    }
  }

  void _calculateDuration() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Translations.getTranslation(widget.currentLanguage, 'Please select both dates'),
          ),
        ),
      );
      return;
    }

    DateTime startDateTime = _startDate!;
    DateTime endDateTime = _endDate!;

    if (_includeTime && _startTime != null && _endTime != null) {
      startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      endDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );
    }

    if (startDateTime.isAfter(endDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Translations.getTranslation(widget.currentLanguage, 'Start date cannot be after end date'),
          ),
        ),
      );
      return;
    }

    final difference = endDateTime.difference(startDateTime);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    final days = (difference.inDays % 365) % 30;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    setState(() {
      if (_includeTime) {
        _duration =
            '$years years, $months months, $days days, $hours hours, $minutes minutes';
      } else {
        _duration = '$years years, $months months, $days days';
      }
    });
  }

  Widget _buildDateCard(
      String title, DateTime? date, TimeOfDay? time, VoidCallback onTap) {
    final theme = Theme.of(context);
    final bool hasDate = date != null;
    final bool hasTime = time != null && _includeTime;

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
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (hasDate)
              Text(
                DateFormat('MMMM d, yyyy').format(date),
                style: const TextStyle(fontSize: 18),
              )
            else
              Text(
                Translations.getTranslation(widget.currentLanguage, 'Select date'),
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            if (_includeTime) ...[
              const SizedBox(height: 4),
              if (hasTime)
                Text(
                  time.format(context),
                  style: const TextStyle(fontSize: 16),
                )
              else
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Select time'),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_duration.isEmpty) return const SizedBox.shrink();

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
                  Icons.timer,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Result'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _duration,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'Duration Calculator'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
                _startTime = null;
                _endTime = null;
                _duration = '';
              });
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 8),
                    const Text(
                      'Include Time',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Switch(
                      value: _includeTime,
                      onChanged: (bool value) {
                        setState(() {
                          _includeTime = value;
                          if (!value) {
                            _startTime = null;
                            _endTime = null;
                          }
                          _duration = '';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDateCard(
              Translations.getTranslation(widget.currentLanguage, 'Start Date'),
              _startDate,
              _startTime,
              () => _selectStartDate(context),
            ),
            const SizedBox(height: 16),
            _buildDateCard(
              Translations.getTranslation(widget.currentLanguage, 'End Date'),
              _endDate,
              _endTime,
              () => _selectEndDate(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateDuration,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                Translations.getTranslation(widget.currentLanguage, 'Calculate Duration'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }
}
