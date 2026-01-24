import 'package:project_manager/models/task.dart';

/// Abstract interface for task storage
///
/// **Key difference from ProjectRepository:**
/// Tasks have a `getByProjectId` method because tasks belong to projects.
/// You'll often need to query "all tasks for project X"
abstract class TaskRepository {
  List<Task> getAll();

  /// Get all tasks for a specific project
  List<Task> getByProjectId(String projectId);

  /// Get a single task by ID
  Task? getById(String id);

  Task create(Task task);

  Task update(Task task);

  bool delete(String id);
}
