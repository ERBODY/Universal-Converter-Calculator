import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../utils/translations.dart';

/// Modern, unified design system for Universal Converter Calculator
/// Ensures consistent styling, animations, and user experience across all pages
class ModernTheme {
  static const Color _primaryColor = Color(0xFF1976D2);
  static const Color _secondaryColor = Color(0xFF2196F3);
  static const Color _accentColor = Color(0xFF4CAF50);
  static const Color _errorColor = Color(0xFFFF5252);
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _successColor = Color(0xFF4CAF50);

  static const Color _surfaceColor = Color(0xFFFAFAFA);
  static const Color _surfaceDark = Color(0xFF121212);
  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _backgroundDark = Color(0xFF000000);

  static const double _borderRadius = 16.0;
  static const double _cardElevation = 4.0;
  static const double _buttonHeight = 56.0;
  static const double _iconSize = 24.0;
  static const double _spacing = 16.0;
  static const double _spacingSmall = 8.0;

  // Gradients
  static const LinearGradient _primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_primaryColor, _secondaryColor],
  );

  static const LinearGradient _successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_successColor, _accentColor],
  );

  // Text Styles
  static TextStyle _headlineStyle(Color textColor) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'SF Pro Display',
  );

  static TextStyle _titleStyle(Color textColor) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textColor,
    fontFamily: 'SF Pro Display',
    letterSpacing: 0.5,
  );

  static TextStyle _subtitleStyle(Color textColor) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor,
    fontFamily: 'SF Pro Text',
    height: 1.4,
  );

  static TextStyle _bodyStyle(Color textColor) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textColor,
    fontFamily: 'SF Pro Text',
    height: 1.5,
  );

  static TextStyle _captionStyle(Color textColor) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textColor,
    fontFamily: 'SF Pro Text',
    height: 1.4,
  );

  // Card Styles
  static BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
    color: isDark ? _surfaceDark : _surfaceColor,
    borderRadius: BorderRadius.circular(_borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration _glassDecoration(bool isDark) => BoxDecoration(
    color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
    borderRadius: BorderRadius.circular(_borderRadius),
    border: Border.all(
      color: (isDark ? Colors.white : Colors.black).withOpacity(0.2),
      width: 1,
    ),
  );

  // Button Styles
  static ButtonStyle _primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    minimumSize: const Size.fromHeight(_buttonHeight),
  );

  static ButtonStyle _secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: _primaryColor,
    side: const BorderSide(color: _primaryColor, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    minimumSize: const Size.fromHeight(_buttonHeight),
  );

  static ButtonStyle _successButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: _successColor,
    foregroundColor: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    minimumSize: const Size.fromHeight(_buttonHeight),
  );

  // Input Field Styles
  static InputDecoration _inputFieldDecoration(String label, IconData? icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: _subtitleStyle(isDark ? Colors.white : _primaryColor),
      prefixIcon: icon != null ? Icon(icon, color: _primaryColor, size: 20) : null,
      filled: true,
      fillColor: (isDark ? _surfaceDark : _surfaceColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : Colors.black12,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : Colors.black12,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: _bodyStyle(isDark ? Colors.white38 : Colors.black38),
    );
  }

  // Animations
  static Duration _animationDuration = const Duration(milliseconds: 300);
  static Curve _animationCurve = Curves.easeInOutCubic;

  // Responsive breakpoints
  static double _mobileBreakpoint = 600;
  static double _tabletBreakpoint = 1024;

  // Helper methods
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= _mobileBreakpoint &&
           MediaQuery.of(context).size.width < _tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletBreakpoint;
  }

  // Theme-specific methods
  static Color getPrimaryTextColor(bool isDark) => isDark ? Colors.white : _primaryColor;
  static Color getSecondaryTextColor(bool isDark) => isDark ? Colors.white70 : Colors.black87;
  static Color getCardTextColor(bool isDark) => isDark ? Colors.white : _primaryColor;
}

/// Modern animated container with consistent styling
class ModernContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool useGlass;
  final bool animate;
  final double? width;
  final double? height;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget container = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.only(bottom: _spacing),
      padding: padding ?? const EdgeInsets.all(_spacing),
      decoration: useGlass
          ? ModernTheme._glassDecoration(isDark)
          : ModernTheme._cardDecoration(isDark).copyWith(
              color: backgroundColor ?? (isDark ? _surfaceDark : _surfaceColor),
            ),
    );

    if (animate) {
      return AnimatedContainer(
        duration: ModernTheme._animationDuration,
        curve: ModernTheme._animationCurve,
        decoration: useGlass
            ? ModernTheme._glassDecoration(isDark)
            : ModernTheme._cardDecoration(isDark),
        child: container,
      );
    }

    return container;
  }
}

/// Modern elevated card for consistent content display
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? childPadding;
  final Color? backgroundColor;
  final bool useGlass;
  final VoidCallback? onTap;
  final bool animate;
  final double? width;

  const ModernCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.childPadding,
    this.backgroundColor,
    this.useGlass = false,
    this.onTap,
    this.animate = true,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget card = Container(
      width: width,
      margin: margin ?? const EdgeInsets.only(bottom: _spacing),
      decoration: useGlass
          ? ModernTheme._glassDecoration(isDark)
          : ModernTheme._cardDecoration(isDark).copyWith(
              color: backgroundColor ?? (isDark ? _surfaceDark : _surfaceColor),
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(_spacing),
            child: childPadding != null
                ? Padding(padding: childPadding!, child: child)
                : child,
          ),
        ),
      ),
    );

    if (animate) {
      return AnimatedContainer(
        duration: ModernTheme._animationDuration,
        curve: ModernTheme._animationCurve,
        decoration: useGlass
            ? ModernTheme._glassDecoration(isDark)
            : ModernTheme._cardDecoration(isDark),
        child: card,
      );
    }

    return card;
  }
}

/// Modern header component with gradient background
class ModernHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget>? actions;
  final String languageCode;
  final bool showBackButton;

  const ModernHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actions,
    required this.languageCode,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRTL = Translations.isRTL(languageCode);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: ModernTheme._primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(_borderRadius),
          bottomRight: Radius.circular(_borderRadius),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _spacing, vertical: 12),
          child: Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if (showBackButton) ...[
                IconButton(
                  icon: Icon(
                    isRTL ? Icons.arrow_forward : Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
              ],
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.white,
                  size: _iconSize,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: ModernTheme._headlineStyle(Colors.white),
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: ModernTheme._bodyStyle(Colors.white70),
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ],
                ),
              ),
              if (actions != null) ...[
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Modern button with consistent styling and animations
class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;

  const ModernButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ButtonStyle buttonStyle = style ?? (isSecondary
        ? ModernTheme._secondaryButtonStyle
        : ModernTheme._primaryButtonStyle);

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle.copyWith(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        minimumSize: Size(width ?? double.infinity, _buttonHeight),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: textColor ?? Colors.white,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: ModernTheme._bodyStyle(textColor ?? Colors.white),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );

    return AnimatedContainer(
      duration: ModernTheme._animationDuration,
      curve: ModernTheme._animationCurve,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? _primaryColor).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: button,
    );
  }
}

/// Modern input field with consistent styling
class ModernInputField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final IconData? suffixIcon;
  final int maxLines;
  final String languageCode;

  const ModernInputField({
    Key? key,
    this.label,
    this.hintText,
    this.controller,
    this.icon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.suffixIcon,
    this.maxLines = 1,
    required this.languageCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: ModernTheme._animationDuration,
      curve: ModernTheme._animationCurve,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: validator,
        style: ModernTheme._bodyStyle(ModernTheme.getPrimaryTextColor(isDark)),
        decoration: ModernTheme._inputFieldDecoration(
          label ?? '',
          icon,
          isDark,
        ).copyWith(
          hintText: hintText,
        ),
      ),
    );
  }
}

/// Modern result display card
class ModernResultCard extends StatelessWidget {
  final String title;
  final String result;
  final String? unit;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final String languageCode;

  const ModernResultCard({
    Key? key,
    required this.title,
    required this.result,
    this.unit,
    this.icon,
    this.backgroundColor,
    this.textColor,
    required this.languageCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: ModernTheme._animationDuration,
      curve: ModernTheme._animationCurve,
      child: ModernCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (backgroundColor ?? _primaryColor).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: backgroundColor ?? _primaryColor,
                  size: _iconSize,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: ModernTheme._titleStyle(ModernTheme.getPrimaryTextColor(isDark)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                gradient: ModernTheme._successGradient,
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              child: Text(
                '$result${unit != null ? ' $unit' : ''}',
                style: ModernTheme._headlineStyle(textColor ?? Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modern dropdown with consistent styling
class ModernDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final String? hintText;
  final String languageCode;
  final bool isExpanded;

  const ModernDropdown({
    Key? key,
    this.value,
    required this.items,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.languageCode,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRTL = Translations.isRTL(languageCode);

    return AnimatedContainer(
      duration: ModernTheme._animationDuration,
      curve: ModernTheme._animationCurve,
      child: ModernInputField(
        label: labelText,
        hintText: hintText,
        controller: TextEditingController(text: value?.toString() ?? ''),
        languageCode: languageCode,
        icon: Icons.arrow_drop_down,
        onSuffixIconTap: () {
          // Show dropdown if needed
        },
        obscureText: true, // Makes it look like a dropdown
        validator: (value) => value != null ? null : 'Required',
      ),
    );
  }
}

/// Loading indicator
class ModernLoadingIndicator extends StatelessWidget {
  final String? message;
  final double? progress;
  final Color? color;

  const ModernLoadingIndicator({
    Key? key,
    this.message,
    this.progress,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (color ?? _primaryColor).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(color ?? _primaryColor),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                if (progress != null)
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        '${(progress! * 100).toInt()}%',
                        style: ModernTheme._bodyStyle(Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: ModernTheme._bodyStyle(ModernTheme.getPrimaryTextColor(isDark)),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Utility for showing modern dialogs
class ModernDialog {
  static void showInfo(BuildContext context, String title, String content, String languageCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? ModernTheme._surfaceDark
            : ModernTheme._surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        title: Text(
          title,
          style: ModernTheme._titleStyle(ModernTheme.getPrimaryTextColor(
              Theme.of(context).brightness == Brightness.dark)),
        ),
        content: Text(
          content,
          style: ModernTheme._bodyStyle(ModernTheme.getSecondaryTextColor(
              Theme.of(context).brightness == Brightness.dark)),
        ),
        actions: [
          ModernButton(
            text: Translations.getTranslation(languageCode, 'ok'),
            onPressed: () => Navigator.pop(context),
            isSecondary: true,
          ),
        ],
      ),
    );
  }

  static Future<bool> showConfirmation(
    BuildContext context,
    String title,
    String content,
    String languageCode,
    {String confirmText = '', String cancelText = ''}
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? ModernTheme._surfaceDark
            : ModernTheme._surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        title: Text(
          title,
          style: ModernTheme._titleStyle(ModernTheme.getPrimaryTextColor(
              Theme.of(context).brightness == Brightness.dark)),
        ),
        content: Text(
          content,
          style: ModernTheme._bodyStyle(ModernTheme.getSecondaryTextColor(
              Theme.of(context).brightness == Brightness.dark)),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ModernButton(
                text: cancelText.isNotEmpty
                    ? cancelText
                    : Translations.getTranslation(languageCode, 'cancel'),
                onPressed: () => Navigator.pop(context, false),
                isSecondary: true,
                width: 100,
              ),
              const SizedBox(width: 8),
              ModernButton(
                text: confirmText.isNotEmpty
                    ? confirmText
                    : Translations.getTranslation(languageCode, 'confirm'),
                onPressed: () => Navigator.pop(context, true),
                width: 100,
              ),
            ],
          ),
        ],
      ),
    );

    return result ?? false;
  }
}