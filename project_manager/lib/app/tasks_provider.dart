import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/providers.dart';
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/data/models/task.dart';

final tasksProvider = NotifierProvider.autoDispose
    .family<TasksNotifier, List<Task>, String>(TasksNotifier.new);

class TasksNotifier extends Notifier<List<Task>> {
  final String projectId;

  TasksNotifier(this.projectId);

  @override
  List<Task> build() {
    return ref.read(taskServiceProvider).getTasksByProjectId(projectId);
  }

  void add({
    required String name,
    required String parentId,
    String? description,
    DateTime? dueDate,
    Status? status,
    PriorityLevel? priority,
  }) {
    final task = ref
        .read(taskServiceProvider)
        .createTask(
          name: name,
          parentId: parentId,
          description: description,
          dueDate: dueDate,
          status: status,
          priority: priority,
        );
    state = [...state, task];
  }
}
