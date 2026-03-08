// This is a form DTO (Data Transfer Object)
// Not a real model - just a temporary object to hold form data
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/data/models/status.dart';

class ProjectCreationModel {
  String? name;
  String? description;
  String? categoryId;
  DateTime? deadline;
  PriorityLevel? priority;
  ProjectStatus? status;
  List<String>? tags;
  double? weight;

  ProjectCreationModel({
    this.name,
    this.description,
    this.categoryId,
    this.deadline,
    this.priority,
    this.status,
    this.tags,
    this.weight,
  });

  static ProjectCreationModel fromProject(Project project) {
    return ProjectCreationModel(
      name: project.name,
      description: project.description,
      categoryId: project.categoryId,
      deadline: project.deadline,
      priority: project.priority,
      status: project.status,
      tags: project.tags,
      weight: project.weight,
    );
  }

  Project toProject(String id) {
    return Project(
      id: id,
      name: name!,
      description: description,
      categoryId: categoryId!,
      deadline: deadline,
      priority: priority ?? PriorityLevel.no,
      status: status ?? ProjectStatus.notStarted,
      tags: tags,
      weight: weight,
      updatedAt: DateTime.now(),
    );
  }
}
