import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/providers.dart';
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/data/models/task.dart';

final tasksProvider = NotifierProvider.autoDispose<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);

class TasksNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    return ref.read(taskServiceProvider).getAllTasks();
  }

  void add({
    required String name,
    String? parentId,
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

final projectTasksProvider = Provider.autoDispose.family<List<Task>, String>((
  ref,
  projectId,
) {
  final allTasks = ref.watch(tasksProvider);
  return allTasks.where((t) => t.parentId == projectId).toList();
});
