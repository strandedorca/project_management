// Project model
class Project {
  // All properties
  // For now everything is a string
  final String id;
  final String name;
  final String? description; // Made nullable since it's optional

  final String categoryId;
  final List<String>? tags;
  final String? type;
  final ProjectStatus status;

  final DateTime startDate;
  final DateTime endDate;

  final double progress;
  final double weight;

  final String color;

  final DateTime deadline;

  final DateTime updatedAt;

  // Constructor
  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    this.type,
    this.tags,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.weight,
    required this.color,
    required this.deadline,
    required this.updatedAt,
  });

  // int get progressPercentage => int.parse(progress);
  // int get progressPercentage => (progress * 100).round();

  // Check if the project is overdue
  // bool get isOverdue => DateTime.now().isAfter(deadline);

  // Get days until deadline (negative if overdue)
  // int get daysUntilDeadline => deadline.difference(DateTime.now()).inDays;
}

// Project status enum
enum ProjectStatus {
  ongoing('Ongoing'),
  notStarted('Not Started'),
  completed('Completed');

  final String label;

  const ProjectStatus(this.label);
}
