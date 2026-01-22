import 'package:project_manager/models/project.dart';

/// Abstract interface for project storage
/// 
/// **What is abstract?**
/// - Defines what methods exist, but not how they work
/// - Like a contract: "Any project storage must have these methods"
/// 
/// **Why abstract?**
/// - Can swap implementations later (in-memory → database → API)
/// - UI doesn't care HOW data is stored, just WHAT operations are available
/// 
/// **How it works:**
/// - This is just a blueprint
/// - Actual implementations will "implement" this interface
/// - UI code uses this interface, not specific implementations
abstract class ProjectRepository {
  /// Get all projects
  /// 
  /// **Returns:** List of all projects
  /// **Why:** Need to display all projects, filter them, count them
  List<Project> getAll();
  
  /// Get a single project by ID
  /// 
  /// **Parameters:**
  /// - `id`: Unique identifier of the project
  /// 
  /// **Returns:** Project if found, null if not found
  /// **Why:** Need to show project details, edit a specific project
  Project? getById(String id);
  
  /// Create a new project
  /// 
  /// **Parameters:**
  /// - `project`: The project to create (must have all required fields)
  /// 
  /// **Returns:** The created project (with ID assigned if needed)
  /// **Why:** User creates a new project in the form
  Project create(Project project);
  
  /// Update an existing project
  /// 
  /// **Parameters:**
  /// - `project`: The updated project (must have same ID as existing)
  /// 
  /// **Returns:** The updated project
  /// **Why:** User edits a project (changes name, deadline, etc.)
  Project update(Project project);
  
  /// Delete a project by ID
  /// 
  /// **Parameters:**
  /// - `id`: Unique identifier of the project to delete
  /// 
  /// **Returns:** true if deleted, false if not found
  /// **Why:** User wants to remove a project
  bool delete(String id);
}
