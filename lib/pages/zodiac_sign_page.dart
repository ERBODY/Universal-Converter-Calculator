import 'package:flutter/material.dart';
import '../utils/translations.dart';
import 'package:intl/intl.dart';

class ZodiacSignPage extends StatefulWidget {
  final String currentLanguage;
  const ZodiacSignPage({super.key, required this.currentLanguage});

  @override
  _ZodiacSignPageState createState() => _ZodiacSignPageState();
}

class _ZodiacSignPageState extends State<ZodiacSignPage> {
  DateTime? _selectedDate;
  String? _zodiacSign;
  String? _zodiacDescription;
  bool _hasCalculated = false;

  void _resetCalculator() {
    setState(() {
      _selectedDate = null;
      _zodiacSign = null;
      _zodiacDescription = null;
      _hasCalculated = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calculateZodiacSign();
      });
    }
  }

  void _calculateZodiacSign() {
    if (_selectedDate == null) return;

    final month = _selectedDate!.month;
    final day = _selectedDate!.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      _zodiacSign = 'Aries';
      _zodiacDescription = 'Energetic, confident, and enthusiastic';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      _zodiacSign = 'Taurus';
      _zodiacDescription = 'Patient, reliable, and practical';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      _zodiacSign = 'Gemini';
      _zodiacDescription = 'Adaptable, versatile, and communicative';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      _zodiacSign = 'Cancer';
      _zodiacDescription = 'Emotional, intuitive, and protective';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      _zodiacSign = 'Leo';
      _zodiacDescription = 'Creative, passionate, and generous';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      _zodiacSign = 'Virgo';
      _zodiacDescription = 'Analytical, practical, and hardworking';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      _zodiacSign = 'Libra';
      _zodiacDescription = 'Diplomatic, gracious, and fair-minded';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      _zodiacSign = 'Scorpio';
      _zodiacDescription = 'Passionate, determined, and resourceful';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      _zodiacSign = 'Sagittarius';
      _zodiacDescription = 'Optimistic, adventurous, and philosophical';
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      _zodiacSign = 'Capricorn';
      _zodiacDescription = 'Responsible, disciplined, and self-controlled';
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      _zodiacSign = 'Aquarius';
      _zodiacDescription = 'Progressive, original, and independent';
    } else {
      _zodiacSign = 'Pisces';
      _zodiacDescription = 'Intuitive, artistic, and compassionate';
    }

    setState(() {
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
                  Translations.getTranslation(widget.currentLanguage, 'Select Birth Date'),
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
                Icons.cake,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                Translations.getTranslation(widget.currentLanguage, 'Birth Date'),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                _selectedDate != null
                    ? DateFormat('MMMM d, yyyy').format(_selectedDate!)
                    : Translations.getTranslation(
                        widget.currentLanguage, 'No date selected'),
                style: TextStyle(
                  color: _selectedDate != null
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              onTap: () => _selectDate(context),
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
                  Icons.stars,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  Translations.getTranslation(widget.currentLanguage, 'Your Zodiac Sign'),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _zodiacSign!,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _zodiacDescription!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedDate != null) ...[
              const SizedBox(height: 16),
              Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'Zodiac Sign'),
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
