// This is a form DTO (Data Transfer Object)
// Not a real model - just a temporary object to hold form data
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';

class ProjectCreationModel {
  String? name;
  String? description;
  String? categoryId;
  DateTime? deadline;
  PriorityLevel? priority;
  ProjectStatus? status;
  List<String>? tags;

  ProjectCreationModel({
    this.name,
    this.description,
    this.categoryId,
    this.deadline,
    this.priority,
    this.status,
    this.tags,
  });
}
