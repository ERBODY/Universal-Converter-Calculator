import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'utils/translations.dart';

void main() {
  runApp(const UniversalConverterCalculatorApp());
}

class UniversalConverterCalculatorApp extends StatefulWidget {
  const UniversalConverterCalculatorApp({super.key});

  @override
  _UniversalConverterCalculatorAppState createState() =>
      _UniversalConverterCalculatorAppState();
}

class _UniversalConverterCalculatorAppState
    extends State<UniversalConverterCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLightTheme = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLightTheme = prefs.getBool('isLightTheme') ?? false;
      _themeMode = _isLightTheme ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _toggleTheme(bool isLightTheme) async {
    setState(() {
      _isLightTheme = isLightTheme;
      _themeMode = _isLightTheme ? ThemeMode.light : ThemeMode.dark;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightTheme', _isLightTheme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Translations.getTranslation('en', 'app_title'),
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          surface: Colors.grey[850]!,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      themeMode: _themeMode,
      home: HomePage(
        toggleTheme: _toggleTheme,
        isLightTheme: _isLightTheme,
        currentLanguage: 'en',
        changeLanguage:
            (String lang) {}, // Empty function since we only have English
      ),
    );
  }
}
