import 'package:flutter/material.dart';
import '../utils/translations.dart';

class PercentageCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const PercentageCalculatorPage({super.key, required this.currentLanguage});

  @override
  _PercentageCalculatorPageState createState() =>
      _PercentageCalculatorPageState();
}

class _PercentageCalculatorPageState extends State<PercentageCalculatorPage> {
  final _originalValueController = TextEditingController();
  final _percentageController = TextEditingController();
  Map<String, double> _results = {};

  void _clearCalculations() {
    setState(() {
      _originalValueController.clear();
      _percentageController.clear();
      _results.clear();
    });
  }

  Map<String, double> _calculatePercentages(
      double originalValue, double percentage) {
    // Basic percentage
    double basicPercentage = (originalValue * percentage) / 100;

    // Percentage increase
    double increase = originalValue + basicPercentage;

    // Percentage decrease
    double decrease = originalValue - basicPercentage;

    return {
      'basic': basicPercentage,
      'increase': increase,
      'decrease': decrease,
    };
  }

  void _performCalculation() {
    final originalValue = double.tryParse(_originalValueController.text);
    final percentage = double.tryParse(_percentageController.text);

    if (originalValue == null ||
        percentage == null ||
        originalValue <= 0 ||
        percentage < 0 ||
        percentage > 100) {
      setState(() {
        _results.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(widget.currentLanguage,
              'Please enter valid values (percentage between 0-100)')),
        ),
      );
      return;
    }

    setState(() {
      _results = _calculatePercentages(originalValue, percentage);
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
                  Icons.percent,
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
            Text(
              Translations.getTranslation(
                  widget.currentLanguage, 'original_value'),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _originalValueController,
              decoration: InputDecoration(
                hintText: Translations.getTranslation(
                    widget.currentLanguage, 'Enter value'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: theme.colorScheme.primary,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Text(
              Translations.getTranslation(widget.currentLanguage, 'percentage'),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _percentageController,
              decoration: InputDecoration(
                hintText: Translations.getTranslation(
                    widget.currentLanguage, 'Enter value'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.percent,
                  color: theme.colorScheme.primary,
                ),
                suffixText: '%',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _performCalculation,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'calculate'),
                style: const TextStyle(fontSize: 16),
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
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'percentage_calculator')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearCalculations,
            tooltip:
                Translations.getTranslation(widget.currentLanguage, 'Clear'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputCard(),
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 24),
              ResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Percentage Amount'),
                value: _results['basic']!,
                originalValue: double.parse(_originalValueController.text),
                percentage: double.parse(_percentageController.text),
                currentLanguage: widget.currentLanguage,
              ),
              const SizedBox(height: 16),
              ResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Amount After Increase'),
                value: _results['increase']!,
                originalValue: double.parse(_originalValueController.text),
                percentage: double.parse(_percentageController.text),
                isIncrease: true,
                currentLanguage: widget.currentLanguage,
              ),
              const SizedBox(height: 16),
              ResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Amount After Decrease'),
                value: _results['decrease']!,
                originalValue: double.parse(_originalValueController.text),
                percentage: double.parse(_percentageController.text),
                isDecrease: true,
                currentLanguage: widget.currentLanguage,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final String title;
  final double value;
  final double originalValue;
  final double percentage;
  final bool isIncrease;
  final bool isDecrease;
  final String currentLanguage;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    required this.originalValue,
    required this.percentage,
    required this.currentLanguage,
    this.isIncrease = false,
    this.isDecrease = false,
  });

  @override
  Widget build(BuildContext context) {
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
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (isIncrease || isDecrease) ...[
              const SizedBox(height: 8),
              Text(
                '${isIncrease ? '+' : '-'}${percentage.toStringAsFixed(1)}% ${Translations.getTranslation(currentLanguage, 'from')} ${originalValue.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: isIncrease ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
