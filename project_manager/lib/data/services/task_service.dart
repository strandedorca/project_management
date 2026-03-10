import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/data/models/task.dart';
import 'package:project_manager/data/repositories/task_repository.dart';

class TaskService {
  final TaskRepository _repository;

  TaskService(this._repository);

  List<Task> getAllTasks() {
    return _repository.getAll();
  }

  /// Get all tasks for a project
  List<Task> getTasksByProjectId(String projectId) {
    return _repository.getByProjectId(projectId);
  }

  /// Create task with auto-generated ID
  Task createTask({
    required String name,
    String? parentId,
    String? description,
    DateTime? dueDate,
    Status? status,
    PriorityLevel? priority,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final task = Task(
      id: id,
      name: name,
      description: description,
      parentId: parentId ?? 'inbox',
      dueDate: dueDate,
      status: status ?? Status.pending,
      priority: priority ?? PriorityLevel.no,
      updatedAt: DateTime.now(),
    );

    return _repository.create(task);
  }

  /// Update task
  Task updateTask(Task task) {
    final updated = task.copyWith(updatedAt: DateTime.now());
    return _repository.update(updated);
  }

  /// Mark task as completed
  Task completeTask(String taskId) {
    final task = _repository.getById(taskId);
    if (task == null) {
      throw Exception('Task not found: $taskId');
    }
    final completed = task.copyWith(
      status: Status.completed,
      updatedAt: DateTime.now(),
    );
    return _repository.update(completed);
  }

  Task reopenTask(String taskId) {
    final task = _repository.getById(taskId);
    if (task == null) {
      throw Exception('Task not found: $taskId');
    }
    final reopened = task.copyWith(
      status: Status.pending,
      updatedAt: DateTime.now(),
    );
    return _repository.update(reopened);
  }

  /// Delete task
  bool deleteTask(String id) {
    return _repository.delete(id);
  }

  /// Get due tasks (today or in the past)
  // List<Task> getDueTasks() {
  //   final now = DateTime.now();
  //   // Get only tasks with a due date, not completed, and due any time up to the end of today
  //   return _repository.getAll().where((task) {
  //     if (task.dueDate == null) return false;
  //     if (task.status == Status.completed) return false;
  //     // Task is due today or before today if dueDate <= end of today
  //     final endOfToday = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       23,
  //       59,
  //       59,
  //       999,
  //     );
  //     return task.dueDate!.isBefore(endOfToday) ||
  //         task.dueDate!.isAtSameMomentAs(endOfToday);
  //   }).toList()..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  // }
}
