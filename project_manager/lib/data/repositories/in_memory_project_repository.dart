import 'package:project_manager/data/repositories/project_repository.dart';
import 'package:project_manager/models/project.dart';

/// **How it works:**
/// - Stores projects in a List (just like `List<Project> projects = []`)
/// - All operations work on this list
/// - Data is lost when app closes

class InMemoryProjectRepository implements ProjectRepository {
  // Private list - only this class can modify directly
  // The underscore (_) makes it private
  final List<Project> _projects = [];

  /// Make the internal list private + return a copy -> immutable
  @override
  List<Project> getAll() {
    return List.from(_projects); // Return a copy, not the original
  }

  @override
  Project? getById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null; // Not found - return null
    }
  }

  /// **Here:** Just adds to the list!
  /// **In real database:** Would generate ID, handle conflicts, etc.
  @override
  Project create(Project project) {
    _projects.add(project);
    return project; // Return the project we just added
  }

  /// Update existing project

  /// 1. Find the index of the project with matching ID
  /// 2. Replace it with the updated project
  /// 3. If not found, throw an error

  @override
  Project update(Project updatedProject) {
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index == -1) {
      throw Exception('Project not found: ${updatedProject.id}');
    }
    _projects[index] = updatedProject;
    return updatedProject;
  }

  @override
  bool delete(String id) {
    final index = _projects.indexWhere((p) => p.id == id);
    if (index == -1) {
      return false; // Not found
    }
    _projects.removeAt(index);
    return true; // Successfully deleted
  }
}
