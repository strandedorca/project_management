import 'package:project_manager/models/task.dart';

/// Abstract interface for task storage
/// 
/// **Key difference from ProjectRepository:**
/// Tasks have a `getByProjectId` method because tasks belong to projects.
/// You'll often need to query "all tasks for project X"
abstract class TaskRepository {
  /// Get all tasks (across all projects)
  /// 
  /// **Returns:** List of all tasks
  /// **Use case:** Dashboard "Due Tasks" - show tasks from all projects
  List<Task> getAll();
  
  /// Get tasks for a specific project
  /// 
  /// **Parameters:**
  /// - `projectId`: ID of the project
  /// 
  /// **Returns:** List of tasks that belong to this project
  /// **Use case:** Project Detail screen - show all tasks for this project
  /// **Why this exists:** Most common query - "show me all tasks for project X"
  List<Task> getByProjectId(String projectId);
  
  /// Get a single task by ID
  /// 
  /// **Parameters:**
  /// - `id`: Unique identifier of the task
  /// 
  /// **Returns:** Task if found, null if not found
  /// **Use case:** Task Detail screen, updating a specific task
  Task? getById(String id);
  
  /// Create a new task
  /// 
  /// **Parameters:**
  /// - `task`: The task to create (must have projectId)
  /// 
  /// **Returns:** The created task (with ID assigned if needed)
  /// **Use case:** User creates a task in the form
  Task create(Task task);
  
  /// Update an existing task
  /// 
  /// **Parameters:**
  /// - `task`: The updated task (must have same ID as existing)
  /// 
  /// **Returns:** The updated task
  /// **Use case:** User edits a task, marks it complete
  Task update(Task task);
  
  /// Delete a task by ID
  /// 
  /// **Parameters:**
  /// - `id`: Unique identifier of the task to delete
  /// 
  /// **Returns:** true if deleted, false if not found
  /// **Use case:** User wants to remove a task
  bool delete(String id);
}
