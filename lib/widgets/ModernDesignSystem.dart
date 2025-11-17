import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/translations.dart';

/// Complete Modern Design System for Universal Converter Calculator
/// Provides unified styling, components, and animations for all pages
class ModernDesignSystem {
  // Modern Color Palette
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF2196F3);
  static const Color accent = Color(0xFF4CAF50);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF333333);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFF9E9E9E);

  // Typography
  static const String fontFamily = 'SF Pro Display';
  static const double fontSizeHeading = 32;
  static const double fontSizeTitle = 24;
  static const double fontSizeSubtitle = 18;
  static const double fontSizeBody = 16;
  static const double fontSizeCaption = 14;
  static const double letterSpacing = 0.5;

  static const TextStyle heading = TextStyle(
    fontSize: fontSizeHeading,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    height: 1.2,
  );

  static const TextStyle title = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    height: 1.3,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: fontSizeSubtitle,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSizeCaption,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    height: 1.4,
  );

  // Spacing
  static const double spacing = 16;
  static const double spacingSmall = 8;
  static const double spacingTiny = 4;

  // Border Radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;

  // Elevation
  static const double elevationSmall = 2;
  static const double elevationMedium = 4;
  static const double elevationLarge = 8;

  // Animations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Curve animationCurve = Curves.easeInOutCubic;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, accent],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white.withOpacity(0.1), Colors.transparent],
  );

  // Helper Methods
  static TextStyle getHeadingStyle(bool isDark) {
    return heading.copyWith(color: isDark ? textDark : textPrimary);
  }

  static TextStyle getTitleStyle(bool isDark) {
    return title.copyWith(color: isDark ? textDark : textPrimary);
  }

  static TextStyle getSubtitleStyle(bool isDark) {
    return subtitle.copyWith(color: isDark ? textDark : textPrimary);
  }

  static TextStyle getBodyStyle(bool isDark) {
    return body.copyWith(color: isDark ? textDark : textPrimary);
  }

  static TextStyle getCaptionStyle(bool isDark) {
    return caption.copyWith(color: isDark ? textHint : textSecondary);
  }

  static Color getPrimaryTextColor(bool isDark) {
    return isDark ? textDark : textPrimary;
  }

  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? textHint : textSecondary;
  }

  static Color getSurfaceColor(bool isDark) {
    return isDark ? surfaceDark : surfaceLight;
  }

  static Color getCardColor(bool isDark) {
    return isDark ? cardDark : cardLight;
  }

  static Color getBorderColor(bool isDark) {
    return isDark ? borderDark : borderLight;
  }

  static Color getBackgroundColor(bool isDark) {
    return isDark ? backgroundDark : backgroundLight;
  }

  // RTL Support Methods
  static TextDirection getTextDirection(String languageCode) {
    return Translations.isRTL(languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }

  static Alignment getTextAlignment(String languageCode) {
    return Translations.isRTL(languageCode) ? Alignment.centerRight : Alignment.centerLeft;
  }

  static CrossAxisAlignment getCrossAxisAlignment(String languageCode) {
    return Translations.isRTL(languageCode) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  static MainAxisAlignment getMainAxisAlignment(String languageCode) {
    return Translations.isRTL(languageCode) ? MainAxisAlignment.end : MainAxisAlignment.start;
  }

  // Responsive Methods
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint &&
           MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 24;
    return 16;
  }

  static double getResponsiveSpacing(BuildContext context) {
    return isDesktop(context) ? spacingSmall : spacing;
  }
}

/// Modern Container with Glass Morphism and Animation
class ModernContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool useGlass;
  final bool animate;
  final double? width;
  final double? height;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Duration? animationDuration;

  const ModernContainer({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.useGlass = false,
    this.animate = true,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.animationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerWidth = width ?? double.infinity;
    final containerHeight = height;
    final decoration = _getContainerDecoration(isDark, useGlass, backgroundColor, borderRadius);

    Widget container = Container(
      width: containerWidth,
      height: containerHeight,
      margin: margin ?? const EdgeInsets.only(bottom: ModernDesignSystem.spacing),
      padding: padding ?? const EdgeInsets.all(ModernDesignSystem.spacing),
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? ModernDesignSystem.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? ModernDesignSystem.radiusMedium),
          child: child,
        ),
      ),
    );

    if (animate && animationDuration != null) {
      return AnimatedContainer(
        duration: animationDuration!,
        curve: ModernDesignSystem.animationCurve,
        decoration: decoration,
        child: container,
      );
    }

    return container;
  }

  BoxDecoration _getContainerDecoration(
    bool isDark,
    bool useGlass,
    Color? backgroundColor,
    double? borderRadius,
  ) {
    if (useGlass) {
      return BoxDecoration(
        color: (backgroundColor ?? Colors.white).withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius ?? ModernDesignSystem.radiusMedium),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withOpacity(0.2),
          width: 1,
        ),
      );
    }

    return BoxDecoration(
      color: backgroundColor ?? ModernDesignSystem.getCardColor(isDark),
      borderRadius: BorderRadius.circular(borderRadius ?? ModernDesignSystem.radiusMedium),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
        if (!isDark)
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
      ],
    );
  }
}

/// Modern Card with Enhanced Styling
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? childPadding;
  final Color? backgroundColor;
  final bool useGlass;
  final bool animate;
  final double? width;
  final double? height;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Duration? animationDuration;

  const ModernCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.childPadding,
    this.backgroundColor,
    this.useGlass = false,
    this.animate = true,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.animationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ModernContainer(
      margin: margin ?? const EdgeInsets.only(bottom: ModernDesignSystem.spacing),
      padding: padding ?? const EdgeInsets.all(ModernDesignSystem.spacing),
      backgroundColor: backgroundColor,
      useGlass: useGlass,
      animate: animate,
      animationDuration: animationDuration,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? ModernDesignSystem.radiusMedium),
        child: Padding(
          padding: childPadding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// Modern Button with Loading States
class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final bool isOutlined;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final String? languageCode;
  final Duration? animationDuration;

  const ModernButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.isOutlined = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.languageCode,
    this.animationDuration,
  }) : super(key: key);

  @override
  State<ModernButton> createState() => _ModernButtonState();

  void _handleTap() {
    if (onPressed != null && !isLoading) {
      onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final buttonWidth = width ?? double.infinity;
    final buttonHeight = height ?? 56.0;
    final buttonRadius = ModernDesignSystem.radiusSmall;

    // Button Style Configuration
    ButtonStyle buttonStyle;
    if (isOutlined) {
      buttonStyle = OutlinedButton.styleFrom(
        foregroundColor: backgroundColor ?? ModernDesignSystem.primary,
        side: BorderSide(color: backgroundColor ?? ModernDesignSystem.primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: Size(buttonWidth, buttonHeight),
      );
    } else {
      buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ModernDesignSystem.primary,
        foregroundColor: textColor ?? Colors.white,
        elevation: ModernDesignSystem.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: Size(buttonWidth, buttonHeight),
      );
    }

    // Add subtle animation for loading state
    Widget buttonContent = isLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                  backgroundColor: (textColor ?? Colors.white).withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Loading...',
                  style: (textColor ?? Colors.white).copyWith(
                    fontSize: ModernDesignSystem.fontSizeBody,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: ModernDesignSystem.getTextDirection(languageCode ?? 'en'),
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: textColor ?? Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: (textColor ?? Colors.white).copyWith(
                    fontSize: ModernDesignSystem.fontSizeBody,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    Widget animatedButton = AnimatedContainer(
      duration: animationDuration ?? ModernDesignSystem.animationNormal,
      curve: ModernDesignSystem.animationCurve,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonRadius),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? ModernDesignSystem.primary).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(buttonRadius),
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(buttonRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: buttonContent,
          ),
        ),
      ),
    );

    return AnimatedContainer(
      duration: animationDuration ?? ModernDesignSystem.animationNormal,
      curve: ModernDesignSystem.animationCurve,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonRadius),
      ),
      child: animatedButton,
    );
  }
}

class _ModernButtonState extends State<ModernButton> {
  @override
  Widget build(BuildContext context) {
    return widget; // The actual button widget is handled in parent
  }
}

/// Modern Input Field with Enhanced Features
class ModernInputField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final IconData? suffixIcon;
  final int maxLines;
  final String? languageCode;
  final bool showCharCount;
  final Duration? animationDuration;

  const ModernInputField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.icon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.suffixIcon,
    this.maxLines = 1,
    this.languageCode,
    this.showCharCount = false,
    this.animationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: animationDuration ?? ModernDesignSystem.animationNormal,
      curve: ModernDesignSystem.animationCurve,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: ModernDesignSystem.spacingTiny),
              child: Text(
                labelText!,
                style: ModernDesignSystem.getSubtitleStyle(isDark),
                textAlign: ModernDesignSystem.getTextAlignment(languageCode ?? 'en'),
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: ModernDesignSystem.getCardColor(isDark),
              borderRadius: BorderRadius.circular(ModernDesignSystem.radiusMedium),
              border: Border.all(
                color: ModernDesignSystem.getBorderColor(isDark),
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              maxLines: maxLines,
              validator: validator,
              style: ModernDesignSystem.getBodyStyle(isDark),
              textAlign: ModernDesignSystem.getTextDirection(languageCode ?? 'en') == TextDirection.rtl
                  ? TextAlign.right
                  : TextAlign.left,
              decoration: InputDecoration(
                prefixIcon: icon != null
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(icon, color: ModernDesignSystem.getSecondaryTextColor(isDark), size: 20),
                      )
                    : null,
                suffixIcon: suffixIcon != null
                    ? IconButton(
                        icon: Icon(suffixIcon, color: ModernDesignSystem.getSecondaryTextColor(isDark), size: 20),
                        onPressed: onSuffixIconTap,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      )
                    : null,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: ModernDesignSystem.getCaptionStyle(isDark),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: ModernDesignSystem.getSubtitleStyle(isDark),
              ),
            ),
          ),
          if (showCharCount && controller != null) ...[
            const SizedBox(height: ModernDesignSystem.spacingTiny),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: ModernDesignSystem.info,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller!.text.length}',
                  style: ModernDesignSystem.getCaptionStyle(isDark).copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Modern Result Display with Enhanced Visuals
class ModernResultDisplay extends StatelessWidget {
  final String title;
  final String result;
  final String? unit;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final String? languageCode;
  final bool animate;
  final Duration? animationDuration;
  final bool showCopyButton;
  final double? animationDelay;

  const ModernResultDisplay({
    Key? key,
    required this.title,
    required this.result,
    this.unit,
    this.icon,
    this.backgroundColor,
    this.textColor,
    required this.languageCode,
    this.animate = true,
    this.animationDuration,
    this.showCopyButton = false,
    this.animationDelay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: animationDuration ?? ModernDesignSystem.animationSlow,
      curve: ModernDesignSystem.animationCurve,
      child: ModernCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (backgroundColor ?? ModernDesignSystem.success).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: backgroundColor ?? ModernDesignSystem.success,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: ModernDesignSystem.getTitleStyle(isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                gradient: ModernDesignSystem.successGradient,
                borderRadius: BorderRadius.circular(ModernDesignSystem.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: ModernDesignSystem.success.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$result${unit != null ? ' $unit' : ''}',
                    style: ModernDesignSystem.getHeadingStyle(isDark).copyWith(
                          color: textColor ?? Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (showCopyButton) ...[
                    const SizedBox(height: 16),
                    ModernButton(
                      text: 'Copy',
                      icon: Icons.copy,
                      isOutlined: true,
                      textColor: ModernDesignSystem.getPrimaryTextColor(isDark),
                      onPressed: () {
                        // Copy to clipboard functionality would go here
                        Clipboard.setData(ClipboardData(text: '$result${unit != null ? ' $unit' : ''}'));
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}