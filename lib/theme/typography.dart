import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carejournal/theme/colors.dart';

// App Text Theme
final TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: lightColorScheme.onBackground,
  ),
  displayMedium: GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onBackground,
  ),
  displaySmall: GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onBackground,
  ),
  headlineLarge: GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onBackground,
  ),
  headlineMedium: GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onBackground,
  ),
  headlineSmall: GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onBackground,
  ),
  titleLarge: GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: lightColorScheme.onBackground,
  ),
  titleMedium: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: lightColorScheme.onBackground,
  ),
  titleSmall: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: lightColorScheme.onBackground,
  ),
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: lightColorScheme.onBackground,
  ),
  bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: lightColorScheme.onBackground,
  ),
  bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: lightColorScheme.onBackground,
  ),
  labelLarge: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: lightColorScheme.onBackground,
  ),
  labelMedium: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: lightColorScheme.onBackground,
  ),
  labelSmall: GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: lightColorScheme.onBackground,
  ),
);

// Dark Theme Text Styles
final TextTheme darkTextTheme = textTheme.apply(
  bodyColor: darkColorScheme.onBackground,
  displayColor: darkColorScheme.onBackground,
);