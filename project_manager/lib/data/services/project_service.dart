import 'package:project_manager/data/repositories/project_repository.dart';
import 'package:project_manager/models/project.dart';

class ProjectService {
  final ProjectRepository _repository;

  /// Constructor - takes repository as dependency
  /// This is "dependency injection" - service doesn't care which implementation
  ProjectService(this._repository);

  List<Project> getAllProjects() {
    return _repository.getAll();
  }

  Project? getProjectById(String id) {
    return _repository.getById(id);
  }

  /// Create project with auto-generated ID
  /// Business logic: Generate ID, set timestamps
  Project createProject({
    required String name,
    String? description,
    ProjectStatus status = ProjectStatus.notStarted,
    required DateTime startDate,
    required DateTime endDate,
    required double progress,
    required double weight,
    required String color,
    required DateTime deadline,
  }) {
    // Generate ID (simple counter for MVP)
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final project = Project(
      id: id,
      name: name,
      description: description,
      status: status,
      startDate: startDate,
      endDate: endDate,
      progress: progress,
      weight: weight,
      color: color,
      deadline: deadline,
      updatedAt: DateTime.now(),
    );

    return _repository.create(project);
  }

  /// Update project
  Project updateProject(Project project) {
    // Update the project's updatedAt field manually (since copyWith isn't defined)
    final updated = Project(
      id: project.id,
      name: project.name,
      description: project.description,
      status: project.status,
      startDate: project.startDate,
      endDate: project.endDate,
      progress: project.progress,
      weight: project.weight,
      color: project.color,
      deadline: project.deadline,
      updatedAt: DateTime.now(),
      // Add any additional fields from Project as necessary
    );
    return _repository.update(updated);
  }

  /// Delete project
  bool deleteProject(String id) {
    return _repository.delete(id);
  }

  /// Business logic: Get ongoing projects
  List<Project> getOngoingProjects() {
    return _repository
        .getAll()
        .where((p) => p.status == ProjectStatus.ongoing)
        .toList();
  }

  /// Business logic: Get upcoming deadlines (next 1 month)
  List<Project> getUpcomingDeadlines() {
    final now = DateTime.now();
    final oneMonthFromNow = now.add(Duration(days: 30));

    return _repository
        .getAll()
        .where(
          (p) =>
              p.deadline.isAfter(now) && p.deadline.isBefore(oneMonthFromNow),
        )
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }
}
