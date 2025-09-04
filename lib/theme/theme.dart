// /workspaces/finqly/lib/theme/theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static const _textThemeBase = TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Nunito', fontSize: 16),
    bodyMedium: TextStyle(fontFamily: 'Nunito', fontSize: 14),
    bodySmall: TextStyle(fontFamily: 'Nunito', fontSize: 12),
    titleLarge: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold),
  );

  static final ThemeData light = _buildTheme(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.accentPurple,
    ),
    scaffoldBg: AppColors.background,
    cardColor: AppColors.cardBackground,
    dividerColor: AppColors.divider,
    appBarForeground: Colors.white,
    bodyTextColor: AppColors.textPrimary,
    bodyTextSecondary: AppColors.textSecondary,
    bodyTextMuted: AppColors.textMuted,
    elevatedBg: AppColors.primary,
    outlinedFg: AppColors.primary,
    inputFill: AppColors.inputBackground,
    inputBorder: AppColors.border,
    inputFocused: AppColors.primary,
    snackFg: Colors.white,
  );

  static final ThemeData dark = _buildTheme(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.accentPurple,
    ),
    scaffoldBg: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkMuted,
    appBarForeground: Colors.white,
    bodyTextColor: AppColors.darkText,
    bodyTextSecondary: AppColors.darkMuted,
    bodyTextMuted: AppColors.darkMuted,
    elevatedBg: AppColors.accentPurple,
    outlinedFg: AppColors.accentPurple,
    inputFill: AppColors.darkCard,
    inputBorder: AppColors.darkMuted,
    inputFocused: AppColors.accentPurple,
    snackFg: Colors.white,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBg,
    required Color cardColor,
    required Color dividerColor,
    required Color appBarForeground,
    required Color bodyTextColor,
    required Color bodyTextSecondary,
    required Color bodyTextMuted,
    required Color elevatedBg,
    required Color outlinedFg,
    required Color inputFill,
    required Color inputBorder,
    required Color inputFocused,
    required Color snackFg,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: scaffoldBg,
      cardColor: cardColor,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: appBarForeground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white,
        ),
      ),

      textTheme: _textThemeBase.copyWith(
        bodyLarge: _textThemeBase.bodyLarge!.copyWith(color: bodyTextColor),
        bodyMedium: _textThemeBase.bodyMedium!.copyWith(color: bodyTextSecondary),
        bodySmall: _textThemeBase.bodySmall!.copyWith(color: bodyTextMuted),
        titleLarge: _textThemeBase.titleLarge!.copyWith(color: bodyTextColor),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: elevatedBg,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: outlinedFg,
          side: BorderSide(color: outlinedFg, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputFocused, width: 1.6),
        ),
        hintStyle: TextStyle(color: bodyTextMuted),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? Colors.grey[850] : Colors.black87,
        contentTextStyle: TextStyle(color: snackFg, fontFamily: 'Nunito'),
        behavior: SnackBarBehavior.floating,
      ),

      dividerTheme: DividerThemeData(color: dividerColor, space: 1, thickness: 1),

      iconTheme: IconThemeData(color: bodyTextSecondary),

      progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.secondary),

      listTileTheme: ListTileThemeData(iconColor: colorScheme.primary),

      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? colorScheme.primary : inputBorder,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const MaterialStatePropertyAll<Color>(Colors.white),
        trackColor: MaterialStateProperty.resolveWith((states) {
          final selected = states.contains(MaterialState.selected);
          return selected
              ? colorScheme.primary
              : colorScheme.primary.withValues(alpha: 0.35);
        }),
      ),

      chipTheme: ChipThemeData(
        labelStyle: TextStyle(color: bodyTextColor, fontFamily: 'Nunito'),
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        side: BorderSide(color: dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
