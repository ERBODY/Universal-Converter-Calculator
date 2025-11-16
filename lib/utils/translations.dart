class Translations {
  static final Map<String, String> _translations = {
    // General
    'settings': 'Settings',
    'light_theme': 'Light Theme',
    'language': 'Language',
    'app_title': 'Universal Converter & Calculator',
    'Theme': 'Theme',
    'About': 'About',
    'Version': 'Version',
    'Input': 'Input',
    'Result': 'Result',
    'Reset': 'Reset',
    'Clear': 'Clear',
    'This is the': 'This is the',
    'page': 'page',
    'Enter value': 'Enter value',
    'From Unit': 'From Unit',
    'To Unit': 'To Unit',
    'Original': 'Original',
    'from': 'from',
    'From': 'From',
    'To': 'To',
    'Value': 'Value',
    'error': 'Error',
    'ok': 'OK',

    // Calculator Pages
    'unit_conversion': 'Unit Conversion',
    'bmi_calculator': 'BMI Calculator',
    'age_calculator': 'Age Calculator',
    'age_difference': 'Age Difference',
    'calorie_calculator': 'Calorie Calculator',
    'currency_converter': 'Currency Converter',
    'duration_calculator': 'Duration Calculator',
    'event_countdown': 'Event Countdown',
    'file_converter': 'File Converter',
    'percentage_calculator': 'Percentage Calculator',
    'post_tax_calculator': 'Post Tax Calculator',
    'zodiac_sign': 'Zodiac Sign',

    // Form Fields
    'height_cm': 'Height (cm)',
    'weight_kg': 'Weight (kg)',
    'birth_date': 'Birth Date',
    'zodiac': 'Zodiac',
    'calculate': 'Calculate',
    'original_value': 'Original Value',
    'percentage': 'Percentage',
    'price': 'Price',
    'tax_rate': 'Tax Rate (%)',
    'total_wealth': 'Total Wealth',
    'age': 'Age',
    'years': 'years',
    'months': 'months',
    'days': 'days',
    'hours': 'hours',
    'minutes': 'minutes',
    'seconds': 'seconds',
    'first_person_birth_date': 'First Person Birth Date',
    'second_person_birth_date': 'Second Person Birth Date',
    'gender': 'Gender',
    'male': 'Male',
    'female': 'Female',
    'activity_level': 'Activity Level',
    'sedentary': 'Sedentary',
    'lightly_active': 'Lightly Active',
    'moderately_active': 'Moderately Active',
    'very_active': 'Very Active',
    'extra_active': 'Extra Active',
    'event_name': 'Event Name',
    'event_date': 'Event Date',
    'countdown': 'Countdown',

    // Units
    'Length': 'Length',
    'Area': 'Area',
    'weight_and_mass': 'Weight and Mass',
    'Volume': 'Volume',
    'Temperature': 'Temperature',
    'Time': 'Time',
    'Speed': 'Speed',
    'Energy': 'Energy',
    'Power': 'Power',
    'Pressure': 'Pressure',
    'Data': 'Data',
    'Frequency': 'Frequency',

    // Results
    'your_bmi_is': 'Your BMI is',
    'underweight': 'Underweight',
    'normal_weight': 'Normal Weight',
    'overweight': 'Overweight',
    'obese': 'Obese',
    'your_age_is': 'Your age is',
    'age_difference_is': 'Age difference is',
    'daily_calories': 'Daily Calories',
    'calories': 'calories',
    'your_zodiac_sign_is': 'Your zodiac sign is',
    'aries': 'Aries',
    'taurus': 'Taurus',
    'gemini': 'Gemini',
    'cancer': 'Cancer',
    'leo': 'Leo',
    'virgo': 'Virgo',
    'libra': 'Libra',
    'scorpio': 'Scorpio',
    'sagittarius': 'Sagittarius',
    'capricorn': 'Capricorn',
    'aquarius': 'Aquarius',
    'pisces': 'Pisces',
  };

  static String getTranslation(String languageCode, String key) {
    return _translations[key] ?? key;
  }

  static List<String> getSupportedLanguages() {
    return ['en'];
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }
}
