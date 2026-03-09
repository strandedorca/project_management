import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';

class TaskCreationModel {
  TaskCreationModel({
    this.name,
    this.description,
    this.parentId,
    this.deadline,
    this.priority,
    this.status,
  });

  String? name;
  String? description;
  String? parentId;
  DateTime? deadline;
  PriorityLevel? priority;
  Status? status;
}
