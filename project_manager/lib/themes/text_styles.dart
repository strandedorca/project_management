import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

/// Custom text styles for the app
/// 
/// **How to use:**
/// 1. Access via `Theme.of(context).textTheme.styleName`
/// 2. Or use `AppTextStyles.lightTextTheme.styleName` directly
/// 
/// **Example:**
/// ```dart
/// Text('Hello', style: Theme.of(context).textTheme.titleLarge)
/// ```
class AppTextStyles {
  /// Light theme text styles
  /// 
  /// **Text Style Categories:**
  /// - **Display**: Largest text (hero sections, landing pages)
  /// - **Headline**: Section titles, major headings
  /// - **Title**: Card titles, list item titles
  /// - **Body**: Regular text content
  /// - **Label**: Buttons, form labels, small text
  static final TextTheme lightTextTheme = TextTheme(
    // Display styles - Largest text (rarely used)
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),

    // Headline styles - Section headings
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),

    // Title styles - Card titles, list item titles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // Body styles - Regular text content
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),

    // Label styles - Buttons, form labels, chips
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // TODO: If you want to use Google Fonts, uncomment and install:
  // Run: flutter pub add google_fonts
  // Then replace TextStyle with GoogleFonts.inter(...)
  //
  // Example:
  // static final TextTheme lightTextTheme = TextTheme(
  //   titleLarge: GoogleFonts.inter(
  //     fontSize: 22,
  //     fontWeight: FontWeight.w600,
  //   ),
  //   // ... other styles
  // );
}
