import 'package:flutter/material.dart';

import 'colors.dart';

// Create the color scheme for the app
// From the colors defined in the color palette in colors.dart
class AppColorScheme {
  static final ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    // Background color & primary text on background
    // primary: AppColors.background,
    // onPrimary: AppColors.textPrimary,
    primary: AppColors.primary,
    onPrimary: AppColors.textPrimary,
    surface: AppColors.background,
    onSurface: AppColors.textPrimary,

    outline: AppColors.textPrimary,
    outlineVariant: AppColors.transparentPrimary,

    secondary: AppColors.secondary,
    onSecondary: AppColors.textPrimary,
    error: AppColors.error,
    onError: AppColors.textPrimary,
  );
}
