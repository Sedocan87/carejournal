import 'package:flutter/material.dart';

// Light Theme Colors
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006A7A), // Deep Teal
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFB3E5FC),
  onPrimaryContainer: Color(0xFF001F25),
  secondary: Color(0xFF4C6267),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCFE7EC),
  onSecondaryContainer: Color(0xFF071F23),
  tertiary: Color(0xFFFFA07A), // Soft Coral Accent
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDBCF),
  onTertiaryContainer: Color(0xFF28130B),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFF8F8F8), // Warm Off-White
  onSurface: Color(0xFF1A1C1E), // Dark Charcoal
  surfaceContainerHighest: Color(0xFFDBE4E6),
  onSurfaceVariant: Color(0xFF3F484A),
  outline: Color(0xFF6F797B),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF2E3132),
  onInverseSurface: Color(0xFFEFF1F2),
  inversePrimary: Color(0xFF5DD5EF),
);

// Dark Theme Colors
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF5DD5EF), // Lighter Teal for dark mode
  onPrimary: Color(0xFF00363F),
  primaryContainer: Color(0xFF004E5A),
  onPrimaryContainer: Color(0xFFB3E5FC),
  secondary: Color(0xFFB3CAD0),
  onSecondary: Color(0xFF1E3438),
  secondaryContainer: Color(0xFF354B4F),
  onSecondaryContainer: Color(0xFFCFE7EC),
  tertiary: Color(0xFFFFB59C), // Lighter Coral for dark mode
  onTertiary: Color(0xFF4D2416),
  tertiaryContainer: Color(0xFF6A3A2A),
  onTertiaryContainer: Color(0xFFFFDBCF),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFB4AB),
  surface: Color(0xFF1C1C2E), // Deep, warm dark blue/purple
  onSurface: Color(0xFFE2E2E3),
  surfaceContainerHighest: Color(0xFF3F484A),
  onSurfaceVariant: Color(0xFFBFC8CA),
  outline: Color(0xFF899294),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE2E2E3),
  onInverseSurface: Color(0xFF1A1C1E),
  inversePrimary: Color(0xFF006A7A),
);