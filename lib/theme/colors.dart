import 'package:flutter/material.dart';

// Light Theme Colors
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF4285F4), // Modern Blue
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE8F0FE),
  onPrimaryContainer: Color(0xFF0D2B5E),
  secondary: Color(0xFF34A853), // Fresh Green
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE6F4EA),
  onSecondaryContainer: Color(0xFF0D3321),
  tertiary: Color(0xFFEA4335), // Vibrant Red
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFCE8E6),
  onTertiaryContainer: Color(0xFF5D1B16),
  error: Color(0xFFDC3545),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFBE7E9),
  onErrorContainer: Color(0xFF58151C),
  surface: Color(0xFFFAFAFA), // Clean White
  onSurface: Color(0xFF202124), // Google Dark Gray
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
  primary: Color(0xFF8AB4F8), // Softer Blue for dark mode
  onPrimary: Color(0xFF0D2B5E),
  primaryContainer: Color(0xFF1A73E8),
  onPrimaryContainer: Color(0xFFE8F0FE),
  secondary: Color(0xFF81C995), // Softer Green for dark mode
  onSecondary: Color(0xFF0D3321),
  secondaryContainer: Color(0xFF34A853),
  onSecondaryContainer: Color(0xFFE6F4EA),
  tertiary: Color(0xFFF28B82), // Softer Red for dark mode
  onTertiary: Color(0xFF5D1B16),
  tertiaryContainer: Color(0xFFEA4335),
  onTertiaryContainer: Color(0xFFFCE8E6),
  error: Color(0xFFE57373),
  onError: Color(0xFF58151C),
  errorContainer: Color(0xFFDC3545),
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
