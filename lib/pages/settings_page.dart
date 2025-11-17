import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/modern_theme.dart';

class SettingsPage extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isLightTheme;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const SettingsPage({
    super.key,
    required this.toggleTheme,
    required this.isLightTheme,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Translations.isRTL(currentLanguage);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ModernTheme._primaryColor.withOpacity(0.8),
                ModernTheme._primaryColor,
              ],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Modern App Bar
                SliverAppBar(
                  expandedHeight: 120,
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
                  ),
                  centerTitle: ModernResultCard(
                    title: Translations.getTranslation(currentLanguage, 'settings'),
                    result: '',
                    icon: Icons.settings,
                    languageCode: currentLanguage,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
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
                        width: 50,
                      ),
                    ),
                  ],
                ),

                // Language Selection with prominence
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(ModernTheme._spacing),
                    child: ModernCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(ModernTheme._spacing),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.language,
                                      color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                      size: ModernTheme._iconSize,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      Translations.getTranslation(currentLanguage, 'language'),
                                      style: ModernTheme._titleStyle(
                                        ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                    ),
                                  ],
                                ),
                              ),
                              ],
                            ),
                          const SizedBox(height: ModernTheme._spacingSmall),

                          // Current Language Display
                          ModernCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar') ? Colors.white : ModernTheme._primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          currentLanguage == 'ar' ? 'ع' : 'En',
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar') ? ModernTheme._primaryColor : Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Translations.getTranslation(currentLanguage, 'language'),
                                          style: ModernTheme._subtitleStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                        ),
                                        Text(
                                          '${Translations.getLanguageName(currentLanguage)} (${Translations.getLanguageDisplayName(currentLanguage)})',
                                          style: ModernTheme._bodyStyle(ModernTheme.getSecondaryTextColor(currentLanguage == 'ar')),
                                        ),
                                      ],
                                    ),
                                  ],
                              ),
                            ),
                          const SizedBox(height: ModernTheme._spacing),
                          Text(
                            Translations.getTranslation(currentLanguage, 'current_language'),
                            style: ModernTheme._captionStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Theme Toggle Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(ModernTheme._spacing),
                    child: ModernCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Icon(
                                Icons.palette,
                                color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                size: ModernTheme._iconSize,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                Translations.getTranslation(currentLanguage, 'appearance'),
                                style: ModernTheme._titleStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                ),
                            ],
                          ),
                          const SizedBox(height: ModernTheme._spacingSmall),

                          // Theme Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isLightTheme
                                    ? Translations.getTranslation(currentLanguage, 'currently_using_light_theme')
                                    : Translations.getTranslation(currentLanguage, 'currently_using_dark_theme'),
                                style: ModernTheme._bodyStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                              ),
                              ModernButton(
                                text: '',
                                onPressed: () => toggleTheme(!isLightTheme),
                                backgroundColor: Colors.transparent,
                                textColor: Colors.white,
                                width: 80,
                                child: AnimatedSwitch(
                                  value: isLightTheme,
                                  duration: ModernTheme._animationDuration,
                                  switchActiveColor: ModernTheme._primaryColor,
                                  switchInactiveColor: Colors.grey,
                                  activeTrackColor: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                  activeColor: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // About Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(ModernTheme._spacing),
                    child: ModernCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                size: ModernTheme._iconSize,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                Translations.getTranslation(currentLanguage, 'About'),
                                style: ModernTheme._titleStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                ),
                            ],
                          ),
                          const SizedBox(height: ModernTheme._spacingSmall),

                          // Version Info
                          ModernCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                        Icons.system_update,
                                        color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                        size: ModernTheme._iconSize,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      Translations.getTranslation(currentLanguage, 'Version'),
                                        style: ModernTheme._subtitleStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                      'Universal Converter Calculator',
                                      style: ModernTheme._bodyStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                    ),
                                const SizedBox(height: 4),
                                Text(
                                      'Version 2.0.0',
                                      style: ModernTheme._captionStyle(ModernTheme.getSecondaryTextColor(currentLanguage == 'ar')),
                                    ),
                              ],
                            ),
                          ),
                          const SizedBox(height: ModernTheme._spacingSmall),

                          // Security Status
                          ModernCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                        Icons.security,
                                        color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                        size: ModernTheme._iconSize,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      Translations.getTranslation(currentLanguage, 'security_status'),
                                        style: ModernTheme._subtitleStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                      Translations.getTranslation(currentLanguage, 'api_credentials_secured'),
                                      style: ModernTheme._bodyStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                    ),
                                ],
                              ),
                          ],
                          const SizedBox(height: ModernTheme._spacingSmall),

                          // Features Info
                          ModernCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                        Icons.category,
                                        color: ModernTheme.getPrimaryTextColor(currentLanguage == 'ar'),
                                        size: ModernTheme._iconSize,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      Translations.getTranslation(currentLanguage, 'features'),
                                        style: ModernTheme._subtitleStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                      '17 ${Translations.getTranslation(currentLanguage, 'conversion_tools')}',
                                      style: ModernTheme._bodyStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                                    ),
                              ],
                          ],
                          const SizedBox(height: ModernTheme._spacingSmall),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Action Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(ModernTheme._spacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: ModernTheme._spacingSmall),
                        Text(
                              Translations.getTranslation(currentLanguage, 'restart_required'),
                              style: ModernTheme._captionStyle(ModernTheme.getPrimaryTextColor(currentLanguage == 'ar')),
                            ),
                        const SizedBox(height: ModernTheme._spacing),
                        ModernButton(
                          text: Translations.getTranslation(currentLanguage, 'confirm'),
                          onPressed: () {
                            ModernDialog.showConfirmation(
                              context,
                              Translations.getTranslation(currentLanguage, 'restart_app_to_apply_changes'),
                              Translations.getTranslation(currentLanguage, 'restart_required'),
                              confirmText: Translations.getTranslation(currentLanguage, 'confirm'),
                            );
                          },
                          width: double.infinity,
                          height: 56,
                          icon: Icons.refresh,
                          isSecondary: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}