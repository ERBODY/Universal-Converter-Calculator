import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/ModernDesignSystem.dart';

class HomePage extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isLightTheme;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isLightTheme,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Translations.isRTL(currentLanguage);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ModernDesignSystem.primary.withOpacity(0.1),
              ModernDesignSystem.primary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Modern App Header with Language Toggle
              SliverAppBar(
                expandedHeight: 100,
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: 0,
                leading: ModernButton(
                  text: '',
                  onPressed: () => Navigator.pop(context),
                  isSecondary: true,
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  width: 50,
                  icon: Icons.arrow_back_ios,
                  languageCode: currentLanguage,
                ),
                centerTitle: ModernResultDisplay(
                  title: Translations.getTranslation(currentLanguage, 'app_title'),
                  result: '',
                  unit: '',
                  icon: Icons.calculate,
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  languageCode: currentLanguage,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ModernButton(
                      text: '',
                      onPressed: () => _showLanguageSelector(context),
                      isSecondary: true,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                      icon: Icons.language,
                      languageCode: currentLanguage,
                      width: 50,
                    ),
                  ),
                ],
              ),
              ),

              // Main Content Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(ModernDesignSystem.spacing),
                  child: Column(
                    children: [
                      // Welcome Section
                      ModernCard(
                        child: Column(
                          crossAxisAlignment: ModernDesignSystem.getCrossAxisAlignment(currentLanguage),
                          children: [
                            Text(
                              '🌟 ${Translations.getTranslation(currentLanguage, 'Welcome')}',
                              style: ModernDesignSystem.getHeadingStyle(ModernDesignSystem.getPrimaryTextColor(false)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Translations.getTranslation(currentLanguage, 'app_welcome'),
                                  style: ModernDesignSystem.getBodyStyle(ModernDesignSystem.getSecondaryTextColor(false))),
                                  textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Converter Tools Grid
                      _buildToolGrid(context, currentLanguage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolGrid(BuildContext context, String languageCode) {
    final tools = [
      {
        'key': 'age_calculator',
        'title': Translations.getTranslation(languageCode, 'age_calculator'),
        'icon': Icons.cake,
        'color': ModernDesignSystem.info,
      },
      {
        'key': 'percentage_calculator',
        'title': Translations.getTranslation(languageCode, 'percentage_calculator'),
        'icon': Icons.percent,
        'color': ModernDesignSystem.warning,
      },
      {
        'key': 'post_tax_calculator',
        'title': Translations.getTranslation(languageCode, 'post_tax_calculator'),
        'icon': Icons.receipt_long,
        'color': ModernDesignSystem.success,
      },
      {
        'key': 'age_difference',
        'title': Translations.getTranslation(languageCode, 'age_difference'),
        'icon': Icons.people,
        'color': ModernDesignSystem.error,
      },
      {
        'key': 'duration_calculator',
        'title': Translations.getTranslation(languageCode, 'duration_calculator'),
        'icon': Icons.timer,
        'color': ModernDesignSystem.secondary,
      },
      {
        'key': 'calorie_calculator',
        'title': Translations.getTranslation(languageCode, 'calorie_calculator'),
        'icon': Icons.local_dining,
        'color': ModernDesignSystem.primary,
      },
      {
        'key': 'zodiac_sign',
        'title': Translations.getTranslation(languageCode, 'zodiac_sign'),
        'icon': Icons.star,
        'color': ModernDesignSystem.warning,
      },
      {
        'key': 'event_countdown',
        'title': Translations.getTranslation(languageCode, 'event_countdown'),
        'icon': Icons.event,
        'color': ModernDesignSystem.error,
      },
      {
        'key': 'file_converter',
        'title': Translations.getTranslation(languageCode, 'file_converter'),
        'icon': Icons.transform,
        'color': ModernDesignSystem.success,
      },
      {
        'key': 'bmi_calculator',
        'title': Translations.getTranslation(languageCode, 'bmi_calculator'),
        'icon': Icons.accessibility,
        'color': ModernDesignSystem.error,
      },
      {
        'key': 'currency_converter',
        'title': Translations.getTranslation(languageCode, 'currency_converter'),
        'icon': Icons.attach_money,
        'color': ModernDesignSystem.warning,
      },
    ];

    final gridColumns = ModernDesignSystem.isTablet(context) ? 3 : 2;
    final crossAxisCount = gridColumns;

    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        final isRTL = ModernDesignSystem.getTextDirection(languageCode);

        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: ModernDesignSystem.animationCurve,
          child: ModernCard(
            animate: true,
            onTap: () => _navigateToTool(context, tool['key']),
            child: Column(
              crossAxisAlignment: ModernDesignSystem.getCrossAxisAlignment(languageCode),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: tool['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tool['icon'],
                    color: tool['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  tool['title'],
                  style: ModernDesignSystem.getSubtitleStyle(ModernDesignSystem.getPrimaryTextColor(false)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToTool(BuildContext context, String toolKey) {
    // Navigate to specific tool based on key
    switch (toolKey) {
      case 'age_calculator':
        Navigator.pushNamed(context, '/age_calculator');
        break;
      case 'percentage_calculator':
        Navigator.pushNamed(context, '/percentage_calculator');
        break;
      case 'post_tax_calculator':
        Navigator.pushNamed(context, '/post_tax_calculator');
        break;
      case 'age_difference':
        Navigator.pushNamed(context, '/age_difference');
        break;
      case 'duration_calculator':
        Navigator.pushNamed(context, '/duration_calculator');
        break;
      case 'calorie_calculator':
        Navigator.pushNamed(context, '/calorie_calculator');
        break;
      case 'zodiac_sign':
        Navigator.pushNamed(context, '/zodiac_sign');
        break;
      case 'event_countdown':
        Navigator.pushNamed(context, '/event_countdown');
        break;
      case 'file_converter':
        Navigator.pushNamed(context, '/file_converter');
        break;
      case 'bmi_calculator':
        Navigator.pushNamed(context, '/bmi_calculator');
        break;
      case 'currency_converter':
        Navigator.pushNamed(context, '/currency_converter');
        break;
    }
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? ModernDesignSystem.surfaceDark
              : ModernDesignSystem.surfaceLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ModernDesignSystem.spacing),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Translations.getTranslation(currentLanguage, 'select_language'),
                      style: ModernDesignSystem.getTitleStyle(ModernDesignSystem.getPrimaryTextColor(false)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        ModernDesignSystem.getTextDirection(currentLanguage) == TextDirection.rtl
                            ? Icons.arrow_forward
                            : Icons.arrow_back,
                        color: ModernDesignSystem.getPrimaryTextColor(false),
                      ),
                    ),
                  ],
                ),
              ),

              // Language Options
              Expanded(
                child: ListView(
                  children: Translations.getSupportedLanguages().map((language) {
                    final isSelected = language == currentLanguage;
                    final isRTLCurrent = ModernDesignSystem.getTextDirection(language);

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200 + (language == 'ar' ? 100 : 0)),
                      curve: ModernDesignSystem.animationCurve,
                      child: ModernCard(
                        onTap: () {
                          changeLanguage(language);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(ModernDesignSystem.spacing),
                          child: Row(
                            textDirection: isRTLCurrent ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ModernDesignSystem.primaryColor
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                        isRTLCurrent ? 'ع' : 'En',
                                        style: ModernDesignSystem.getTitleStyle(isSelected
                                              ? Colors.white
                                              : ModernDesignSystem.primaryColor,
                                        ).copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Translations.getLanguageName(language),
                                      style: ModernDesignSystem.getSubtitleStyle(ModernDesignSystem.getPrimaryTextColor(false)),
                                    ),
                                    Text(
                                      Translations.getLanguageDisplayName(language),
                                      style: ModernDesignSystem.getBodyStyle(ModernDesignSystem.getSecondaryTextColor(false)),
                                    ),
                                  ],
                                ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}