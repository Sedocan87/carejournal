import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carejournal/theme/colors.dart';

// App Text Theme
final TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: lightColorScheme.onSurface,
  ),
  displayMedium: GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onSurface,
  ),
  displaySmall: GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onSurface,
  ),
  headlineLarge: GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onSurface,
  ),
  headlineMedium: GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onSurface,
  ),
  headlineSmall: GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: lightColorScheme.onSurface,
  ),
  titleLarge: GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: lightColorScheme.onSurface,
  ),
  titleMedium: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: lightColorScheme.onSurface,
  ),
  titleSmall: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: lightColorScheme.onSurface,
  ),
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: lightColorScheme.onSurface,
  ),
  bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: lightColorScheme.onSurface,
  ),
  bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: lightColorScheme.onSurface,
  ),
  labelLarge: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: lightColorScheme.onSurface,
  ),
  labelMedium: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: lightColorScheme.onSurface,
  ),
  labelSmall: GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: lightColorScheme.onSurface,
  ),
);

// Dark Theme Text Styles
final TextTheme darkTextTheme = textTheme.apply(
  bodyColor: darkColorScheme.onSurface,
  displayColor: darkColorScheme.onSurface,
);