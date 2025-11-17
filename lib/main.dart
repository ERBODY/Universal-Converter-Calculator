import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_page.dart';
import 'utils/translations.dart';

void main() async {
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: Could not load .env file: $e');
    print('Please create a .env file based on .env.example');
  }

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
  String _currentLanguage = 'en';

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
      // Default to English, not Arabic
      _currentLanguage = prefs.getString('language') ?? 'en';
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

  void _changeLanguage(String language) async {
    setState(() {
      _currentLanguage = language;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(language, 'language_changed_successfully')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Translations.getTranslation(_currentLanguage, 'app_title'),
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
        currentLanguage: _currentLanguage,
        changeLanguage: _changeLanguage,
      ),
    );
  }
}
