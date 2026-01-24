import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  /// Format as whole number (rounded): 42.7 → "43"
  static String wholeNumber(num value) {
    return value.round().toString();
  }

  /// Format as percentage: 75.23 → "75.23%"
  static String percentage(double value, {int decimalPlaces = 0}) {
    if (decimalPlaces == 0) {
      return '${value.round()}%';
    }
    return '${value.toStringAsFixed(decimalPlaces)}%';
  }

  /// Format as percentage without % symbol: 0.75 → "75"
  static String percentageValue(double value, {int decimalPlaces = 0}) {
    final percentage = value * 100;
    if (decimalPlaces == 0) {
      return percentage.round().toString();
    }
    return percentage.toStringAsFixed(decimalPlaces);
  }

  /// Format with decimal places: 42.789 → "42.79" (2 decimals)
  /// Example: NumberFormatter.decimal(42.789, 2) → "42.79"
  static String decimal(double value, int decimalPlaces) {
    return value.toStringAsFixed(decimalPlaces);
  }

  /// Format with thousand separators: 1234567 → "1,234,567"
  /// Example: NumberFormatter.withCommas(1234567) → "1,234,567"
  static String withCommas(num value) {
    return NumberFormat('#,###').format(value);
  }

  /// Format with thousand separators and decimals: 1234.56 → "1,234.56"
  /// Example: NumberFormatter.withCommasAndDecimals(1234.56, 2) → "1,234.56"
  static String withCommasAndDecimals(double value, int decimalPlaces) {
    return NumberFormat('#,###.${'0' * decimalPlaces}').format(value);
  }

  /// Format as currency: 1234.56 → "$1,234.56" (USD)
  /// Example: NumberFormatter.currency(1234.56) → "$1,234.56"
  static String currency(
    double value, {
    String symbol = '\$',
    int decimalPlaces = 2,
  }) {
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalPlaces,
    ).format(value);
  }

  /// Format as compact number: 1234567 → "1.2M"
  /// Example: NumberFormatter.compact(1234567) → "1.2M"
  static String compact(num value) {
    return NumberFormat.compact().format(value);
  }

  /// Format as compact long: 1234567 → "1.2 million"
  /// Example: NumberFormatter.compactLong(1234567) → "1.2 million"
  static String compactLong(num value) {
    return NumberFormat.compactLong().format(value);
  }

  /// Format file size: 1048576 → "1.0 MB"
  /// Example: NumberFormatter.fileSize(1048576) → "1.0 MB"
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Format duration in seconds: 3661 → "1h 1m 1s"
  /// Example: NumberFormatter.duration(3661) → "1h 1m 1s"
  static String duration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '${minutes}m';
      }
      return '${minutes}m ${remainingSeconds}s';
    } else {
      final hours = seconds ~/ 3600;
      final remainingMinutes = (seconds % 3600) ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingMinutes == 0 && remainingSeconds == 0) {
        return '${hours}h';
      } else if (remainingSeconds == 0) {
        return '${hours}h ${remainingMinutes}m';
      }
      return '${hours}h ${remainingMinutes}m ${remainingSeconds}s';
    }
  }

  /// Format as ordinal: 1 → "1st", 2 → "2nd", 3 → "3rd"
  /// Example: NumberFormatter.ordinal(1) → "1st"
  static String ordinal(int value) {
    final suffix = _getOrdinalSuffix(value);
    return '$value$suffix';
  }

  /// Get ordinal suffix: 1 → "st", 2 → "nd", 3 → "rd"
  static String _getOrdinalSuffix(int value) {
    if (value >= 11 && value <= 13) {
      return 'th';
    }
    switch (value % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Custom format using NumberFormat pattern
  /// Example: NumberFormatter.custom(1234.56, '#,###.00') → "1,234.56"
  static String custom(num value, String pattern) {
    return NumberFormat(pattern).format(value);
  }
}
