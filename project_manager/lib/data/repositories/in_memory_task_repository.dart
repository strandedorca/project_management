import 'package:project_manager/data/repositories/task_repository.dart';
import 'package:project_manager/models/task.dart';

class InMemoryTaskRepository implements TaskRepository {
  // Private list of all tasks
  final List<Task> _tasks = [];

  @override
  List<Task> getAll() {
    return List.from(_tasks); // Return a copy
  }

  /// Get tasks for a specific project
  /// - Filters tasks where `task.projectId == projectId`
  @override
  List<Task> getByProjectId(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }

  @override
  Task? getById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Task create(Task task) {
    _tasks.add(task);
    return task;
  }

  @override
  Task update(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index == -1) {
      throw Exception('Task not found: ${updatedTask.id}');
    }
    _tasks[index] = updatedTask;
    return updatedTask;
  }

  @override
  bool delete(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) {
      return false; // Not found
    }
    _tasks.removeAt(index);
    return true; // Deleted successfully
  }
}
