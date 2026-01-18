/// Task Model - Represents a task/subtask within a project
///
/// **Design Decisions:**
/// 1. Tasks belong to a project (via projectId)
/// 2. Tasks can have optional due dates (not all tasks need deadlines)
/// 3. Tasks track their completion status
/// 4. Immutable model (all fields final)

class Task {
  final String id;
  final String name;

  /// Optional: Can include notes, requirements, acceptance criteria, etc.
  final String? description;

  /// **Why required:**
  /// - Every task must belong to a project
  /// - Used to query "all tasks for project X"
  /// - Used for navigation (go to project from task)
  ///
  /// Relationship: Many tasks → One project (many-to-one)
  final String projectId;

  /// **Why optional?**
  /// - Not all tasks need specific deadlines
  /// - Some tasks might just be "do when you can"
  /// - Used in dashboard "Due Tasks" section
  final DateTime? dueDate;

  final TaskStatus
  status; // Used for: filtering, progress calculation, UI display

  final DateTime createdAt; // Used for: sorting, audit trail

  final DateTime updatedAt; // Used for: tracking changes, future sync features

  // Constructor: used to create a new Task instance
  const Task({
    required this.id,
    required this.name,
    this.description,
    required this.projectId,
    this.dueDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Helper method: Check if task is overdue
  ///
  /// **Returns:** true if task has a due date and it's passed
  /// **Returns:** false if no due date or not yet due
  bool get isOverdue {
    if (dueDate == null) return false; // No due date = can't be overdue
    return DateTime.now().isAfter(dueDate!);
  }

  /// Helper method: Days until due date
  ///
  /// **Returns:** null if no due date
  /// **Returns:** positive number if due in future
  /// **Returns:** negative number if overdue
  int? get daysUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  /// Helper method: Check if task is completed
  ///
  /// **Why a method?** Makes code more readable
  /// Instead of: `task.status == TaskStatus.completed`
  /// Can write: `task.isCompleted`
  bool get isCompleted => status == TaskStatus.completed;

  /// Create a copy of this task with updated fields
  ///
  /// **Usage:**
  /// ```dart
  /// // Mark task as completed
  /// final completed = task.copyWith(
  ///   status: TaskStatus.completed,
  /// );
  /// ```
  Task copyWith({
    String? id,
    String? name,
    String? description,
    String? projectId,
    DateTime? dueDate,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp
    );
  }

  /// Check if two tasks are equal
  ///
  /// **Decision:** Two tasks are equal if they have the same ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  /// Hash code for this task
  @override
  int get hashCode => id.hashCode;
}

/// Task Status Enum
///
/// **Why these three statuses?**
/// - `pending`: Task exists but not started (default state)
/// - `inProgress`: Currently working on it
/// - `completed`: Done!
///
/// **Future consideration:** Could add `blocked`, `cancelled` later
enum TaskStatus {
  /// Task exists but hasn't been started yet
  /// This is the default status when creating a new task
  pending('Pending'),

  /// Task is currently being worked on
  inProgress('In Progress'),

  /// Task is finished
  completed('Completed');

  /// Human-readable label for display in UI
  final String label;

  /// Constructor for enum with label
  const TaskStatus(this.label);
}
