import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/providers.dart';
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/data/models/status.dart';

final projectsProvider = NotifierProvider<ProjectsNotifier, List<Project>>(
  ProjectsNotifier.new,
);

class ProjectsNotifier extends Notifier<List<Project>> {
  @override
  List<Project> build() {
    // Initial state
    return ref.read(projectServiceProvider).getAllProjects();
  }

  void add({
    required String name,
    String? description,
    DateTime? deadline,
    String? categoryId,
    ProjectStatus? status,
    PriorityLevel? priority,
    List<String>? tags,
  }) {
    final project = ref
        .read(projectServiceProvider)
        .createProject(
          name: name,
          description: description,
          deadline: deadline,
          categoryId: categoryId,
          status: status,
          priority: priority,
          tags: tags,
        );
    state = [...state, project];
  }

  void update(Project project) {
    final updated = ref.read(projectServiceProvider).updateProject(project);
    state = state.map((p) => p.id == updated.id ? updated : p).toList();
  }
}
