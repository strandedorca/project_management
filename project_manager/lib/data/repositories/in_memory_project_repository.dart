import 'package:project_manager/models/project.dart';
import 'package:project_manager/data/repositories/project_repository.dart';

/// In-memory implementation of ProjectRepository
/// 
/// **How it works:**
/// - Stores projects in a List (just like `List<Project> projects = []`)
/// - All operations work on this list
/// - Data is lost when app closes (OK for MVP!)
/// 
/// **Why "in-memory"?**
/// - Data lives in RAM, not disk
/// - Fast (no file I/O)
/// - Simple (just Dart List operations)
/// - Perfect for MVP
/// 
/// **Later:** You'll create HiveProjectRepository or DatabaseProjectRepository
/// that implements the same interface, so your UI code doesn't need to change!
class InMemoryProjectRepository implements ProjectRepository {
  // Private list - only this class can modify directly
  // The underscore (_) makes it private
  final List<Project> _projects = [];
  
  /// Get all projects
  /// 
  /// **Why return a copy?**
  /// - Prevents external code from modifying our internal list
  /// - Returns `List.from(_projects)` instead of `_projects`
  /// - External code can modify the copy, but not our original
  @override
  List<Project> getAll() {
    return List.from(_projects); // Return a copy, not the original
  }
  
  /// Get project by ID
  /// 
  /// **How it works:**
  /// - `firstWhere` finds first project where ID matches
  /// - `orElse` returns null if not found
  /// 
  /// **Alternative approach:** Could use try-catch instead
  @override
  Project? getById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null; // Not found - return null
    }
  }
  
  /// Create new project
  /// 
  /// **Simple:** Just adds to the list!
  /// 
  /// **In real database:** Would generate ID, handle conflicts, etc.
  @override
  Project create(Project project) {
    _projects.add(project);
    return project; // Return the project we just added
  }
  
  /// Update existing project
  /// 
  /// **How it works:**
  /// 1. Find the index of the project with matching ID
  /// 2. Replace it with the updated project
  /// 3. If not found, throw an error
  /// 
  /// **Why indexWhere?**
  /// - Finds position in list
  /// - Returns -1 if not found
  /// - Need index to use `list[index] = newValue`
  @override
  Project update(Project updatedProject) {
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index == -1) {
      throw Exception('Project not found: ${updatedProject.id}');
    }
    _projects[index] = updatedProject; // Replace at that position
    return updatedProject;
  }
  
  /// Delete project by ID
  /// 
  /// **How it works:**
  /// 1. Find the index of the project
  /// 2. Remove it from the list
  /// 3. Return true if deleted, false if not found
  /// 
  /// **Why return bool?**
  /// - UI can show different messages
  /// - "Deleted successfully" vs "Project not found"
  @override
  bool delete(String id) {
    final index = _projects.indexWhere((p) => p.id == id);
    if (index == -1) {
      return false; // Not found
    }
    _projects.removeAt(index); // Remove at that position
    return true; // Successfully deleted
  }
}
