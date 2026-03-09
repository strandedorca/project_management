// Project model
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';

class Project {
  // All properties
  final String id;
  final String name;
  final bool isSystem;
  final String? description;
  final DateTime? deadline;
  final String categoryId;
  final Status status;
  final PriorityLevel priority;
  final List<String>? tags;
  final double? weight;

  DateTime updatedAt;

  Project({
    required this.id,
    this.isSystem = false,
    required this.name,
    this.description,
    this.deadline,
    required this.categoryId,
    required this.status,
    required this.priority,
    this.tags,
    this.weight,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isSystem': isSystem,
      'name': name,
      'description': description,
      'deadline': deadline?.toIso8601String(),
      'categoryId': categoryId,
      'status': status.value,
      'priority': priority.value,
      'tags': tags,
      'updatedAt': updatedAt,
    };
  }

  // int get progressPercentage => int.parse(progress);
  // int get progressPercentage => (progress * 100).round();

  // Check if the project is overdue
  // bool get isOverdue => DateTime.now().isAfter(deadline);

  // Get days until deadline (negative if overdue)
  // int get daysUntilDeadline => deadline.difference(DateTime.now()).inDays;
}
