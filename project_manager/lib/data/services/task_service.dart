import 'package:project_manager/data/repositories/task_repository.dart';
import 'package:project_manager/models/task.dart';

class TaskService {
  final TaskRepository _repository;

  TaskService(this._repository);

  /// Get all tasks for a project
  List<Task> getTasksForProject(String projectId) {
    return _repository.getByProjectId(projectId);
  }

  /// Create task with auto-generated ID
  Task createTask({
    required String name,
    String? description,
    required String projectId,
    DateTime? dueDate,
    TaskStatus status = TaskStatus.pending,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    final task = Task(
      id: id,
      name: name,
      description: description,
      projectId: projectId,
      dueDate: dueDate,
      status: status,
    );

    return _repository.create(task);
  }

  /// Update task
  Task updateTask(Task task) {
    final updated = Task(
      id: task.id,
      name: task.name,
      description: task.description,
      projectId: task.projectId,
      dueDate: task.dueDate,
      status: task.status,
      // updatedAt: DateTime.now(),
    );
    return _repository.update(updated);
  }

  /// Mark task as completed
  Task completeTask(String taskId) {
    final task = _repository.getById(taskId);
    if (task == null) {
      throw Exception('Task not found: $taskId');
    }
    return updateTask(
      Task(
        id: task.id,
        name: task.name,
        description: task.description,
        projectId: task.projectId,
        dueDate: task.dueDate,
        status: TaskStatus.completed,
      ),
    );
  }

  /// Delete task
  bool deleteTask(String id) {
    return _repository.delete(id);
  }

  /// Get due tasks (today or in the past)
  List<Task> getDueTasks() {
    final now = DateTime.now();
    // Get only tasks with a due date, not completed, and due any time up to the end of today
    return _repository.getAll().where((task) {
      if (task.dueDate == null) return false;
      if (task.status == TaskStatus.completed) return false;
      // Task is due today or before today if dueDate <= end of today
      final endOfToday = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        999,
      );
      return task.dueDate!.isBefore(endOfToday) ||
          task.dueDate!.isAtSameMomentAs(endOfToday);
    }).toList()..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }
}
