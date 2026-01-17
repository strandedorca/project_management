import 'package:flutter/material.dart';

// This is where I define the color palette for the app
class AppColors {
  static const Color primary = Color(0xFFffca42);
  static const Color secondary = Color(0xFF89beb1);
  static const Color background = Color(0xFFF9F5EB);
  static const Color accent = Color(0xFFf9792f);

  // text
  static const Color textPrimary = Color(0xFF181529);
  static final Color textSecondary = textPrimary.withValues(alpha: 0.8);
  static final Color transparentPrimary = textPrimary.withValues(alpha: 0.25);

  static const Color error = Color(0xFFB00020);

  // Additional custom colors

  // Text colors
  // static const Color onPrimary = Color(0xFFFFFFFF);
  // static const Color onSecondary = Color(0xFF000000);
  // static const Color onBackground = Color(0xFF000000);
  // static const Color onSurface = Color(0xFF000000);
  // static const Color onError = Color(0xFFFFFFFF);
}
