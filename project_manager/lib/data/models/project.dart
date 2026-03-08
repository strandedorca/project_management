// Project model
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';

class Project {
  // All properties
  final String id;

  final String name;
  final String? description; // Made nullable since it's optional
  final DateTime? deadline;
  final String categoryId;
  final ProjectStatus status;
  final PriorityLevel priority;
  final List<String>? tags;
  final double? weight;

  DateTime updatedAt;

  // final String? type;
  // final DateTime startDate;
  // final DateTime endDate;
  // final double progress;

  // final String color;

  // Constructor
  Project({
    required this.id,
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
