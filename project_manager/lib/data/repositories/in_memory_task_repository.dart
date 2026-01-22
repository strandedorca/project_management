import 'package:project_manager/models/task.dart';
import 'package:project_manager/data/repositories/task_repository.dart';

/// In-memory implementation of TaskRepository
/// 
/// **Same pattern as ProjectRepository:**
/// - Stores tasks in a List
/// - Implements all methods from TaskRepository interface
/// - Key method: `getByProjectId` - filters tasks by project
class InMemoryTaskRepository implements TaskRepository {
  // Private list of all tasks
  final List<Task> _tasks = [];
  
  @override
  List<Task> getAll() {
    return List.from(_tasks); // Return copy
  }
  
  /// Get tasks for a specific project
  /// 
  /// **This is the key method!**
  /// - Filters tasks where `task.projectId == projectId`
  /// - Most common query in your app
  /// 
  /// **How it works:**
  /// - `where()` filters the list
  /// - `toList()` converts the iterable to a list
  /// 
  /// **Example:**
  /// ```dart
  /// final tasks = repository.getByProjectId('project-1');
  /// // Returns only tasks where projectId == 'project-1'
  /// ```
  @override
  List<Task> getByProjectId(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }
  
  @override
  Task? getById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null; // Not found
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
