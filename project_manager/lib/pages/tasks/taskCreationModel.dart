import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/data/models/task.dart';

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

  static TaskCreationModel fromTask(Task task) {
    return TaskCreationModel(
      name: task.name,
      description: task.description,
      parentId: task.parentId,
      deadline: task.dueDate,
      priority: task.priority,
      status: task.status,
    );
  }

  Task toTask(String id) {
    return Task(
      id: id,
      name: name!,
      description: description,
      parentId: parentId!,
      dueDate: deadline,
      priority: priority ?? PriorityLevel.no,
      status: status ?? Status.pending,
      updatedAt: DateTime.now(),
    );
  }
}
