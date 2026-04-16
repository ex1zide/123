import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LegalHelp KZ Design System — Deep Black & Gold
///
/// Material 3 Expressive dark theme built for a premium legal-tech brand.
/// All color tokens, typography, and component styles are centralised here.
abstract final class AppTheme {
  // ──────────────────────────── Color Tokens ────────────────────────────
  static const Color _black = Color(0xFF0A0A0A);
  static const Color _surfaceDark = Color(0xFF121212);
  static const Color _surfaceContainer = Color(0xFF1C1C1E);
  static const Color _surfaceContainerHigh = Color(0xFF2C2C2E);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _goldLight = Color(0xFFE8CC6E);
  static const Color _goldDark = Color(0xFFB8941F);
  static const Color _onGold = Color(0xFF1A1400);
  static const Color _white = Color(0xFFF5F5F5);
  static const Color _grey = Color(0xFF8E8E93);
  static const Color _error = Color(0xFFCF6679);

  // ──────────────────────────── Color Scheme ────────────────────────────
  static final ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _gold,
    onPrimary: _onGold,
    primaryContainer: _goldDark,
    onPrimaryContainer: _goldLight,
    secondary: _goldLight,
    onSecondary: _onGold,
    secondaryContainer: _goldDark.withValues(alpha: 0.4),
    onSecondaryContainer: _goldLight,
    tertiary: _goldLight,
    onTertiary: _onGold,
    surface: _surfaceDark,
    onSurface: _white,
    surfaceContainerLowest: _black,
    surfaceContainerLow: _surfaceDark,
    surfaceContainer: _surfaceContainer,
    surfaceContainerHigh: _surfaceContainerHigh,
    surfaceContainerHighest: _surfaceContainerHigh,
    onSurfaceVariant: _grey,
    outline: _grey.withValues(alpha: 0.3),
    outlineVariant: _grey.withValues(alpha: 0.15),
    error: _error,
    onError: _black,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: _white,
    onInverseSurface: _black,
    inversePrimary: _goldDark,
  );

  // ────────────────────────── Typography ──────────────────────────
  static final TextTheme _textTheme = GoogleFonts.interTextTheme(
    ThemeData.dark().textTheme,
  ).copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      color: _white,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45,
      fontWeight: FontWeight.w600,
      color: _white,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: _white,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: _white,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: _white,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: _white,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: _white,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: _white,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: _white,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: _white,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: _white,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: _grey,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: _white,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: _white,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: _grey,
    ),
  );

  // ────────────────────── Component Themes ──────────────────────

  static final _appBarTheme = AppBarTheme(
    backgroundColor: _black,
    foregroundColor: _white,
    elevation: 0,
    scrolledUnderElevation: 2,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _white,
    ),
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _gold,
      foregroundColor: _onGold,
      disabledBackgroundColor: _gold.withValues(alpha: 0.3),
      disabledForegroundColor: _onGold.withValues(alpha: 0.5),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _gold,
      side: const BorderSide(color: _gold, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),
  );

  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _gold,
      textStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: _surfaceContainer,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: _grey.withValues(alpha: 0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _gold, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _error, width: 2),
    ),
    labelStyle: GoogleFonts.inter(color: _grey, fontSize: 14),
    hintStyle: GoogleFonts.inter(color: _grey.withValues(alpha: 0.6)),
    prefixIconColor: _grey,
    suffixIconColor: _grey,
    floatingLabelStyle: GoogleFonts.inter(color: _gold),
  );

  static final _cardTheme = CardThemeData(
    color: _surfaceContainer,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: _grey.withValues(alpha: 0.1)),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  );

  static final _bottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: _black,
    selectedItemColor: _gold,
    unselectedItemColor: _grey,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  );

  static final _navigationBarTheme = NavigationBarThemeData(
    backgroundColor: _black,
    indicatorColor: _gold.withValues(alpha: 0.15),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: _gold, size: 24);
      }
      return const IconThemeData(color: _grey, size: 24);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _gold,
        );
      }
      return GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _grey,
      );
    }),
  );

  static final _snackBarTheme = SnackBarThemeData(
    backgroundColor: _surfaceContainerHigh,
    contentTextStyle: GoogleFonts.inter(color: _white, fontSize: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
  );

  static final _dialogTheme = DialogThemeData(
    backgroundColor: _surfaceContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: _white,
    ),
    contentTextStyle: GoogleFonts.inter(
      fontSize: 14,
      color: _grey,
    ),
  );

  // ────────────────────── Public ThemeData ──────────────────────

  /// The single dark [ThemeData] for the entire app.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _colorScheme,
        scaffoldBackgroundColor: _black,
        textTheme: _textTheme,
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        cardTheme: _cardTheme,
        bottomNavigationBarTheme: _bottomNavTheme,
        navigationBarTheme: _navigationBarTheme,
        snackBarTheme: _snackBarTheme,
        dialogTheme: _dialogTheme,
        dividerTheme: DividerThemeData(
          color: _grey.withValues(alpha: 0.15),
          thickness: 0.5,
        ),
        splashFactory: InkSparkle.splashFactory,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}
