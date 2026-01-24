import 'package:intl/intl.dart';

/// JavaScript/React-style approach: Top-level functions
/// 
/// **Usage:**
/// ```dart
/// import 'package:project_manager/utils/date_formatter_functions.dart';
/// 
/// Text(shortDate(project.deadline))
/// ```
/// 
/// This is more similar to JavaScript exports!

/// Short date format: "Jan 24, 2026"
String shortDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

/// Medium date format: "January 24, 2026"
String mediumDate(DateTime date) {
  return DateFormat('MMMM d, yyyy').format(date);
}

/// Long date format: "Friday, January 24, 2026"
String longDate(DateTime date) {
  return DateFormat('EEEE, MMMM d, yyyy').format(date);
}

/// Date only (no time): "2026-01-24"
String dateOnly(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

/// Time only: "3:45 PM"
String timeOnly(DateTime date) {
  return DateFormat('h:mm a').format(date);
}

/// Date and time: "Jan 24, 2026 3:45 PM"
String dateTime(DateTime date) {
  return DateFormat('MMM d, yyyy h:mm a').format(date);
}

/// Relative date: "Today", "Tomorrow", "In 3 days"
String relativeDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final difference = target.difference(today).inDays;

  if (difference == 0) {
    return 'Today';
  } else if (difference == 1) {
    return 'Tomorrow';
  } else if (difference == -1) {
    return 'Yesterday';
  } else if (difference > 0 && difference < 7) {
    return 'In $difference days';
  } else if (difference < 0 && difference > -7) {
    return '${difference.abs()} days ago';
  } else if (difference >= 7 && difference < 30) {
    final weeks = (difference / 7).floor();
    return 'In $weeks ${weeks == 1 ? 'week' : 'weeks'}';
  } else if (difference <= -7 && difference > -30) {
    final weeks = (difference.abs() / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  } else {
    return shortDate(date);
  }
}

/// Days until date: "Due in 3 days" or "Overdue by 2 days"
String daysUntil(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final difference = target.difference(today).inDays;

  if (difference == 0) {
    return 'Due today';
  } else if (difference == 1) {
    return 'Due tomorrow';
  } else if (difference > 1) {
    return 'Due in $difference days';
  } else {
    return 'Overdue by ${difference.abs()} ${difference.abs() == 1 ? 'day' : 'days'}';
  }
}

/// Custom format: customDate(DateTime.now(), 'dd/MM/yyyy')
String customDate(DateTime date, String pattern) {
  return DateFormat(pattern).format(date);
}
