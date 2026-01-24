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
///
abstract class ProjectRepository {
  List<Project> getAll();

  Project? getById(String id);

  Project create(Project project);

  Project update(Project project);

  bool delete(String id);
}
