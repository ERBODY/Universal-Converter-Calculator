import 'package:flutter/material.dart';
import '../utils/translations.dart';

class PostTaxCalculatorPage extends StatefulWidget {
  final String currentLanguage;

  const PostTaxCalculatorPage({
    super.key,
    required this.currentLanguage,
  });

  @override
  _PostTaxCalculatorPageState createState() => _PostTaxCalculatorPageState();
}

class _PostTaxCalculatorPageState extends State<PostTaxCalculatorPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _finalPrice = 0;
  double _taxAmount = 0;
  bool _hasCalculated = false;

  @override
  void dispose() {
    _priceController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _priceController.clear();
      _taxRateController.clear();
      _finalPrice = 0;
      _taxAmount = 0;
      _hasCalculated = false;
    });
  }

  void _calculateFinalPrice() {
    if (_formKey.currentState?.validate() ?? false) {
      final price = double.tryParse(_priceController.text) ?? 0;
      final taxRate = double.tryParse(_taxRateController.text) ?? 0;

      setState(() {
        _taxAmount = price * taxRate / 100;
        _finalPrice = price + _taxAmount;
        _hasCalculated = true;
      });
    }
  }

  Widget _buildInputCard(String title, TextEditingController controller,
      String label, String errorMessage, bool isPrice) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPrice ? Icons.attach_money : Icons.percent,
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
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  isPrice ? Icons.monetization_on : Icons.percent,
                  color: theme.colorScheme.primary,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorMessage;
                }
                final number = double.tryParse(value);
                if (number == null || (isPrice ? number <= 0 : number < 0)) {
                  return Translations.getTranslation(widget.currentLanguage,
                      isPrice ? 'invalid price' : 'invalid tax rate');
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _hasCalculated = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final theme = Theme.of(context);
    return Card(
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
                  Translations.getTranslation(widget.currentLanguage, 'Result'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildResultRow(
              Translations.getTranslation(widget.currentLanguage, 'Original Price'),
              double.tryParse(_priceController.text) ?? 0,
            ),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
            _buildResultRow(
              Translations.getTranslation(widget.currentLanguage, 'Tax Amount'),
              _taxAmount,
              color: theme.colorScheme.error,
            ),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
            _buildResultRow(
              Translations.getTranslation(widget.currentLanguage, 'Final Price'),
              _finalPrice,
              isFinal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double amount,
      {Color? color, bool isFinal = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isFinal ? 18 : 16,
              fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: isFinal ? 18 : 16,
              fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
              color: color ?? theme.colorScheme.onSurface,
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
        title: Text(
          Translations.getTranslation(
              widget.currentLanguage, 'Post Tax Calculator'),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputCard(
                  Translations.getTranslation(widget.currentLanguage, 'Price'),
                  _priceController,
                  Translations.getTranslation(
                      widget.currentLanguage, 'Enter original price'),
                  Translations.getTranslation(
                      widget.currentLanguage, 'price required'),
                  true,
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  Translations.getTranslation(
                      widget.currentLanguage, 'Tax Rate'),
                  _taxRateController,
                  Translations.getTranslation(
                      widget.currentLanguage, 'Enter tax rate (%)'),
                  Translations.getTranslation(
                      widget.currentLanguage, 'tax rate required'),
                  false,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateFinalPrice,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    Translations.getTranslation(
                        widget.currentLanguage, 'Calculate'),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                if (_hasCalculated) ...[
                  const SizedBox(height: 24),
                  _buildResultCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
