import 'package:flutter/material.dart';
import '../utils/translations.dart';

class CurrencyConverterPage extends StatefulWidget {
  final String currentLanguage;
  const CurrencyConverterPage({super.key, required this.currentLanguage});

  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  String? _fromCurrency;
  String? _toCurrency;
  double _convertedValue = 0;
  bool _hasCalculated = false;

  @override
  void initState() {
    super.initState();
    _fromCurrency = 'USD';
    _toCurrency = 'EUR';
  }

  // Note: These are example rates. In a real app, you'd fetch current rates from an API
  final Map<String, Map<String, dynamic>> _currencies = {
    'USD': {'name': 'US Dollar', 'country': 'United States', 'rate': 1.0},
    'EUR': {'name': 'Euro', 'country': 'European Union', 'rate': 0.92},
    'GBP': {'name': 'British Pound', 'country': 'United Kingdom', 'rate': 0.79},
    'JPY': {'name': 'Japanese Yen', 'country': 'Japan', 'rate': 150.27},
    'AUD': {'name': 'Australian Dollar', 'country': 'Australia', 'rate': 1.53},
    'CAD': {'name': 'Canadian Dollar', 'country': 'Canada', 'rate': 1.35},
    'CHF': {'name': 'Swiss Franc', 'country': 'Switzerland', 'rate': 0.88},
    'CNY': {'name': 'Chinese Yuan', 'country': 'China', 'rate': 7.20},
    'INR': {'name': 'Indian Rupee', 'country': 'India', 'rate': 82.89},
    'NZD': {
      'name': 'New Zealand Dollar',
      'country': 'New Zealand',
      'rate': 1.64
    },
    'AED': {
      'name': 'UAE Dirham',
      'country': 'United Arab Emirates',
      'rate': 3.67
    },
    'AFN': {'name': 'Afghan Afghani', 'country': 'Afghanistan', 'rate': 73.50},
    'ALL': {'name': 'Albanian Lek', 'country': 'Albania', 'rate': 95.80},
    'AMD': {'name': 'Armenian Dram', 'country': 'Armenia', 'rate': 386.50},
    'ANG': {
      'name': 'Netherlands Antillean Guilder',
      'country': 'Netherlands Antilles',
      'rate': 1.79
    },
    'AOA': {'name': 'Angolan Kwanza', 'country': 'Angola', 'rate': 825.00},
    'ARS': {'name': 'Argentine Peso', 'country': 'Argentina', 'rate': 870.00},
    'AWG': {'name': 'Aruban Florin', 'country': 'Aruba', 'rate': 1.80},
    'AZN': {'name': 'Azerbaijani Manat', 'country': 'Azerbaijan', 'rate': 1.70},
    'BAM': {
      'name': 'Bosnia-Herzegovina Convertible Mark',
      'country': 'Bosnia and Herzegovina',
      'rate': 1.80
    },
    'BBD': {'name': 'Barbadian Dollar', 'country': 'Barbados', 'rate': 2.00},
    'BDT': {
      'name': 'Bangladeshi Taka',
      'country': 'Bangladesh',
      'rate': 109.50
    },
    'BGN': {'name': 'Bulgarian Lev', 'country': 'Bulgaria', 'rate': 1.80},
    'BHD': {'name': 'Bahraini Dinar', 'country': 'Bahrain', 'rate': 0.38},
    'BIF': {'name': 'Burundian Franc', 'country': 'Burundi', 'rate': 2850.00},
    'BMD': {'name': 'Bermudan Dollar', 'country': 'Bermuda', 'rate': 1.00},
    'BND': {'name': 'Brunei Dollar', 'country': 'Brunei', 'rate': 1.35},
    'BOB': {'name': 'Bolivian Boliviano', 'country': 'Bolivia', 'rate': 6.91},
    'BRL': {'name': 'Brazilian Real', 'country': 'Brazil', 'rate': 5.40},
    'BSD': {'name': 'Bahamian Dollar', 'country': 'Bahamas', 'rate': 1.00},
    'BTN': {'name': 'Bhutanese Ngultrum', 'country': 'Bhutan', 'rate': 83.00},
    'BWP': {'name': 'Botswanan Pula', 'country': 'Botswana', 'rate': 13.50},
    'BYN': {'name': 'Belarusian Ruble', 'country': 'Belarus', 'rate': 3.20},
    'BZD': {'name': 'Belize Dollar', 'country': 'Belize', 'rate': 2.00},
    'CDF': {
      'name': 'Congolese Franc',
      'country': 'Democratic Republic of the Congo',
      'rate': 2500.00
    },
    'CLP': {'name': 'Chilean Peso', 'country': 'Chile', 'rate': 920.00},
    'COP': {'name': 'Colombian Peso', 'country': 'Colombia', 'rate': 3900.00},
    'CRC': {
      'name': 'Costa Rican Colón',
      'country': 'Costa Rica',
      'rate': 520.00
    },
    'CUP': {'name': 'Cuban Peso', 'country': 'Cuba', 'rate': 24.00},
    'CVE': {
      'name': 'Cape Verdean Escudo',
      'country': 'Cape Verde',
      'rate': 101.00
    },
    'CZK': {'name': 'Czech Koruna', 'country': 'Czech Republic', 'rate': 23.00},
    'DJF': {'name': 'Djiboutian Franc', 'country': 'Djibouti', 'rate': 178.00},
    'DKK': {'name': 'Danish Krone', 'country': 'Denmark', 'rate': 6.85},
    'DOP': {
      'name': 'Dominican Peso',
      'country': 'Dominican Republic',
      'rate': 58.50
    },
    'DZD': {'name': 'Algerian Dinar', 'country': 'Algeria', 'rate': 134.00},
    'EGP': {'name': 'Egyptian Pound', 'country': 'Egypt', 'rate': 47.00},
    'ERN': {'name': 'Eritrean Nakfa', 'country': 'Eritrea', 'rate': 15.00},
    'ETB': {'name': 'Ethiopian Birr', 'country': 'Ethiopia', 'rate': 56.00},
    'FJD': {'name': 'Fijian Dollar', 'country': 'Fiji', 'rate': 2.25},
    'FKP': {
      'name': 'Falkland Islands Pound',
      'country': 'Falkland Islands',
      'rate': 0.79
    },
    'FOK': {'name': 'Faroese Króna', 'country': 'Faroe Islands', 'rate': 6.85},
    'GEL': {'name': 'Georgian Lari', 'country': 'Georgia', 'rate': 2.70},
    'GGP': {'name': 'Guernsey Pound', 'country': 'Guernsey', 'rate': 0.79},
    'GHS': {'name': 'Ghanaian Cedi', 'country': 'Ghana', 'rate': 13.00},
    'GIP': {'name': 'Gibraltar Pound', 'country': 'Gibraltar', 'rate': 0.79},
    'GMD': {'name': 'Gambian Dalasi', 'country': 'Gambia', 'rate': 67.00},
    'GNF': {'name': 'Guinean Franc', 'country': 'Guinea', 'rate': 8600.00},
    'GTQ': {'name': 'Guatemalan Quetzal', 'country': 'Guatemala', 'rate': 7.80},
    'GYD': {'name': 'Guyanaese Dollar', 'country': 'Guyana', 'rate': 209.00},
    'HKD': {'name': 'Hong Kong Dollar', 'country': 'Hong Kong', 'rate': 7.80},
    'HNL': {'name': 'Honduran Lempira', 'country': 'Honduras', 'rate': 24.70},
    'HRK': {'name': 'Croatian Kuna', 'country': 'Croatia', 'rate': 7.00},
    'HTG': {'name': 'Haitian Gourde', 'country': 'Haiti', 'rate': 132.00},
    'HUF': {'name': 'Hungarian Forint', 'country': 'Hungary', 'rate': 360.00},
    'IDR': {
      'name': 'Indonesian Rupiah',
      'country': 'Indonesia',
      'rate': 15700.00
    },
    'ILS': {'name': 'Israeli New Shekel', 'country': 'Israel', 'rate': 3.70},
    'IMP': {'name': 'Manx pound', 'country': 'Isle of Man', 'rate': 0.79},
    'IQD': {'name': 'Iraqi Dinar', 'country': 'Iraq', 'rate': 1310.00},
    'IRR': {'name': 'Iranian Rial', 'country': 'Iran', 'rate': 42000.00},
    'ISK': {'name': 'Icelandic Króna', 'country': 'Iceland', 'rate': 138.00},
    'JEP': {'name': 'Jersey Pound', 'country': 'Jersey', 'rate': 0.79},
    'JMD': {'name': 'Jamaican Dollar', 'country': 'Jamaica', 'rate': 155.00},
    'JOD': {'name': 'Jordanian Dinar', 'country': 'Jordan', 'rate': 0.71},
    'KES': {'name': 'Kenyan Shilling', 'country': 'Kenya', 'rate': 129.00},
    'KGS': {'name': 'Kyrgystani Som', 'country': 'Kyrgyzstan', 'rate': 89.00},
    'KHR': {'name': 'Cambodian Riel', 'country': 'Cambodia', 'rate': 4100.00},
    'KID': {'name': 'Kiribati Dollar', 'country': 'Kiribati', 'rate': 1.53},
    'KMF': {'name': 'Comorian Franc', 'country': 'Comoros', 'rate': 453.00},
    'KRW': {
      'name': 'South Korean Won',
      'country': 'South Korea',
      'rate': 1350.00
    },
    'KWD': {'name': 'Kuwaiti Dinar', 'country': 'Kuwait', 'rate': 0.31},
    'KYD': {
      'name': 'Cayman Islands Dollar',
      'country': 'Cayman Islands',
      'rate': 0.83
    },
    'KZT': {
      'name': 'Kazakhstani Tenge',
      'country': 'Kazakhstan',
      'rate': 450.00
    },
    'LAK': {'name': 'Laotian Kip', 'country': 'Laos', 'rate': 20500.00},
    'LBP': {'name': 'Lebanese Pound', 'country': 'Lebanon', 'rate': 15000.00},
    'LKR': {'name': 'Sri Lankan Rupee', 'country': 'Sri Lanka', 'rate': 310.00},
    'LRD': {'name': 'Liberian Dollar', 'country': 'Liberia', 'rate': 190.00},
    'LSL': {'name': 'Lesotho Loti', 'country': 'Lesotho', 'rate': 18.50},
    'LYD': {'name': 'Libyan Dinar', 'country': 'Libya', 'rate': 4.80},
    'MAD': {'name': 'Moroccan Dirham', 'country': 'Morocco', 'rate': 10.00},
    'MDL': {'name': 'Moldovan Leu', 'country': 'Moldova', 'rate': 17.80},
    'MGA': {
      'name': 'Malagasy Ariary',
      'country': 'Madagascar',
      'rate': 4400.00
    },
    'MKD': {
      'name': 'Macedonian Denar',
      'country': 'North Macedonia',
      'rate': 57.00
    },
    'MMK': {'name': 'Myanmar Kyat', 'country': 'Myanmar', 'rate': 2100.00},
    'MNT': {'name': 'Mongolian Tugrik', 'country': 'Mongolia', 'rate': 3400.00},
    'MOP': {'name': 'Macanese Pataca', 'country': 'Macao', 'rate': 8.05},
    'MRU': {
      'name': 'Mauritanian Ouguiya',
      'country': 'Mauritania',
      'rate': 39.00
    },
    'MUR': {'name': 'Mauritian Rupee', 'country': 'Mauritius', 'rate': 45.50},
    'MVR': {'name': 'Maldivian Rufiyaa', 'country': 'Maldives', 'rate': 15.40},
    'MWK': {'name': 'Malawian Kwacha', 'country': 'Malawi', 'rate': 1650.00},
    'MXN': {'name': 'Mexican Peso', 'country': 'Mexico', 'rate': 16.80},
    'MYR': {'name': 'Malaysian Ringgit', 'country': 'Malaysia', 'rate': 4.70},
    'MZN': {
      'name': 'Mozambican Metical',
      'country': 'Mozambique',
      'rate': 63.50
    },
    'NAD': {'name': 'Namibian Dollar', 'country': 'Namibia', 'rate': 18.50},
    'NGN': {'name': 'Nigerian Naira', 'country': 'Nigeria', 'rate': 1450.00},
    'NIO': {
      'name': 'Nicaraguan Córdoba',
      'country': 'Nicaragua',
      'rate': 36.50
    },
    'NOK': {'name': 'Norwegian Krone', 'country': 'Norway', 'rate': 10.70},
    'NPR': {'name': 'Nepalese Rupee', 'country': 'Nepal', 'rate': 133.00},
    'OMR': {'name': 'Omani Rial', 'country': 'Oman', 'rate': 0.38},
    'PAB': {'name': 'Panamanian Balboa', 'country': 'Panama', 'rate': 1.00},
    'PEN': {'name': 'Peruvian Sol', 'country': 'Peru', 'rate': 3.70},
    'PGK': {
      'name': 'Papua New Guinean Kina',
      'country': 'Papua New Guinea',
      'rate': 3.70
    },
    'PHP': {'name': 'Philippine Peso', 'country': 'Philippines', 'rate': 56.50},
    'PKR': {'name': 'Pakistani Rupee', 'country': 'Pakistan', 'rate': 278.00},
    'PLN': {'name': 'Polish Złoty', 'country': 'Poland', 'rate': 3.95},
    'PYG': {
      'name': 'Paraguayan Guarani',
      'country': 'Paraguay',
      'rate': 7300.00
    },
    'QAR': {'name': 'Qatari Rial', 'country': 'Qatar', 'rate': 3.64},
    'RON': {'name': 'Romanian Leu', 'country': 'Romania', 'rate': 4.60},
    'RSD': {'name': 'Serbian Dinar', 'country': 'Serbia', 'rate': 108.00},
    'RUB': {'name': 'Russian Ruble', 'country': 'Russia', 'rate': 92.00},
    'RWF': {'name': 'Rwandan Franc', 'country': 'Rwanda', 'rate': 1250.00},
    'SAR': {'name': 'Saudi Riyal', 'country': 'Saudi Arabia', 'rate': 3.75},
    'SBD': {
      'name': 'Solomon Islands Dollar',
      'country': 'Solomon Islands',
      'rate': 8.40
    },
    'SCR': {
      'name': 'Seychellois Rupee',
      'country': 'Seychelles',
      'rate': 13.20
    },
    'SDG': {'name': 'Sudanese Pound', 'country': 'Sudan', 'rate': 600.00},
    'SEK': {'name': 'Swedish Krona', 'country': 'Sweden', 'rate': 10.50},
    'SGD': {'name': 'Singapore Dollar', 'country': 'Singapore', 'rate': 1.35},
    'SHP': {
      'name': 'Saint Helena Pound',
      'country': 'Saint Helena',
      'rate': 0.79
    },
    'SLE': {
      'name': 'Sierra Leonean Leone',
      'country': 'Sierra Leone',
      'rate': 22.50
    },
    'SLL': {
      'name': 'Sierra Leonean Leone (old)',
      'country': 'Sierra Leone',
      'rate': 19500.00
    },
    'SOS': {'name': 'Somali Shilling', 'country': 'Somalia', 'rate': 570.00},
    'SRD': {'name': 'Surinamese Dollar', 'country': 'Suriname', 'rate': 36.50},
    'SSP': {
      'name': 'South Sudanese Pound',
      'country': 'South Sudan',
      'rate': 990.00
    },
    'STN': {
      'name': 'São Tomé and Príncipe Dobra',
      'country': 'São Tomé and Príncipe',
      'rate': 22.70
    },
    'SYP': {'name': 'Syrian Pound', 'country': 'Syria', 'rate': 13000.00},
    'SZL': {'name': 'Swazi Lilangeni', 'country': 'Eswatini', 'rate': 18.50},
    'THB': {'name': 'Thai Baht', 'country': 'Thailand', 'rate': 35.80},
    'TJS': {
      'name': 'Tajikistani Somoni',
      'country': 'Tajikistan',
      'rate': 11.00
    },
    'TMT': {
      'name': 'Turkmenistani Manat',
      'country': 'Turkmenistan',
      'rate': 3.50
    },
    'TND': {'name': 'Tunisian Dinar', 'country': 'Tunisia', 'rate': 3.10},
    'TOP': {'name': 'Tongan Paʻanga', 'country': 'Tonga', 'rate': 2.40},
    'TRY': {'name': 'Turkish Lira', 'country': 'Turkey', 'rate': 32.00},
    'TTD': {
      'name': 'Trinidad and Tobago Dollar',
      'country': 'Trinidad and Tobago',
      'rate': 6.80
    },
    'TVD': {'name': 'Tuvaluan Dollar', 'country': 'Tuvalu', 'rate': 1.53},
    'TWD': {'name': 'New Taiwan Dollar', 'country': 'Taiwan', 'rate': 32.00},
    'TZS': {
      'name': 'Tanzanian Shilling',
      'country': 'Tanzania',
      'rate': 2550.00
    },
    'UAH': {'name': 'Ukrainian Hryvnia', 'country': 'Ukraine', 'rate': 39.50},
    'UGX': {'name': 'Ugandan Shilling', 'country': 'Uganda', 'rate': 3800.00},
    'UYU': {'name': 'Uruguayan Peso', 'country': 'Uruguay', 'rate': 39.00},
    'UZS': {
      'name': 'Uzbekistani Som',
      'country': 'Uzbekistan',
      'rate': 12500.00
    },
    'VES': {
      'name': 'Venezuelan Bolívar',
      'country': 'Venezuela',
      'rate': 36.50
    },
    'VND': {'name': 'Vietnamese Đồng', 'country': 'Vietnam', 'rate': 25000.00},
    'VUV': {'name': 'Vanuatu Vatu', 'country': 'Vanuatu', 'rate': 120.00},
    'WST': {'name': 'Samoan Tala', 'country': 'Samoa', 'rate': 2.75},
    'XAF': {
      'name': 'Central African CFA Franc',
      'country': 'CEMAC',
      'rate': 605.00
    },
    'XCD': {
      'name': 'East Caribbean Dollar',
      'country': 'Organisation of Eastern Caribbean States',
      'rate': 2.70
    },
    'XDR': {
      'name': 'Special Drawing Rights',
      'country': 'International Monetary Fund',
      'rate': 0.74
    },
    'XOF': {'name': 'West African CFA franc', 'country': 'CFA', 'rate': 605.00},
    'XPF': {
      'name': 'CFP Franc',
      'country': 'Collectivités d\'Outre-Mer',
      'rate': 110.00
    },
    'YER': {'name': 'Yemeni Rial', 'country': 'Yemen', 'rate': 250.00},
    'ZAR': {
      'name': 'South African Rand',
      'country': 'South Africa',
      'rate': 18.50
    },
    'ZMW': {'name': 'Zambian Kwacha', 'country': 'Zambia', 'rate': 26.00},
    'ZWL': {
      'name': 'Zimbabwean Dollar',
      'country': 'Zimbabwe',
      'rate': 9650.00
    },
  };

  void _resetCalculator() {
    setState(() {
      _inputController.clear();
      _fromCurrency = null;
      _toCurrency = null;
      _convertedValue = 0;
      _hasCalculated = false;
    });
  }

  void _convertCurrency() {
    if (_fromCurrency == null || _toCurrency == null) return;

    final inputValue = double.tryParse(_inputController.text);
    if (inputValue == null) return;

    setState(() {
      // Convert to USD first (as base currency), then to target currency
      final inUSD = inputValue / _currencies[_fromCurrency]!['rate'];
      _convertedValue = inUSD * _currencies[_toCurrency]!['rate'];
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
                  Icons.currency_exchange,
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
            TextFormField(
              controller: _inputController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'Enter amount'),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.input,
                  color: theme.colorScheme.primary,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) _convertCurrency();
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _fromCurrency,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'From Currency'),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.arrow_downward,
                  color: theme.colorScheme.primary,
                ),
              ),
              items: _currencies.keys
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(
                            '$currency - ${_currencies[currency]!['name']} (${_currencies[currency]!['country']})'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _fromCurrency = value;
                  if (_inputController.text.isNotEmpty) _convertCurrency();
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _toCurrency,
              decoration: InputDecoration(
                labelText: Translations.getTranslation(
                    widget.currentLanguage, 'To Currency'),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.arrow_upward,
                  color: theme.colorScheme.primary,
                ),
              ),
              items: _currencies.keys
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(
                            '$currency - ${_currencies[currency]!['name']} (${_currencies[currency]!['country']})'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _toCurrency = value;
                  if (_inputController.text.isNotEmpty) _convertCurrency();
                });
              },
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _convertedValue.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _toCurrency ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (_fromCurrency != null) ...[
              const SizedBox(height: 16),
              Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
              const SizedBox(height: 8),
              Text(
                '${Translations.getTranslation(widget.currentLanguage, 'Original')}: ${_inputController.text} ${_fromCurrency!}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Translations.getTranslation(widget.currentLanguage,
                    'Note: Exchange rates are for demonstration only'),
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
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
          Translations.getTranslation(
              widget.currentLanguage, 'Currency Converter'),
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
