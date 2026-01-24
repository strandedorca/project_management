import 'package:intl/intl.dart';

/// Extension methods on DateTime - Very Flutter-like approach!
///
/// **Usage:**
/// ```dart
/// import 'package:project_manager/utils/date_extensions.dart';
///
/// Text(project.deadline.toShortDate())
/// Text(date.toRelativeDate())
/// ```
///
/// This is the most "Flutter-like" approach - very clean syntax!

extension DateTimeExtensions on DateTime {
  /// Short date format: "Jan 24, 2026"
  String toShortDate() {
    return DateFormat('MMM d, yyyy').format(this);
  }

  /// Medium date format: "January 24, 2026"
  String toMediumDate() {
    return DateFormat('MMMM d, yyyy').format(this);
  }

  /// Long date format: "Friday, January 24, 2026"
  String toLongDate() {
    return DateFormat('EEEE, MMMM d, yyyy').format(this);
  }

  /// Date only: "2026-01-24"
  String toDateOnly() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Time only: "3:45 PM"
  String toTimeOnly() {
    return DateFormat('h:mm a').format(this);
  }

  /// Date and time: "Jan 24, 2026 3:45 PM"
  String toDateTime() {
    return DateFormat('MMM d, yyyy h:mm a').format(this);
  }

  /// Relative date: "Today", "Tomorrow", "In 3 days"
  String toRelativeDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(year, month, day);
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
      return toShortDate();
    }
  }

  /// Days until: "Due in 3 days" or "Overdue by 2 days"
  String toDaysUntil() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(year, month, day);
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

  /// Custom format: date.toCustom('dd/MM/yyyy')
  String toCustom(String pattern) {
    return DateFormat(pattern).format(this);
  }
}
