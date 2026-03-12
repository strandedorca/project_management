import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/components/taskList.dart';
import 'package:project_manager/data/models/task.dart';
import 'package:project_manager/data/sample_due_tasks.dart';

// Due Tasks section contains a list of tasks that are either:
// - Due today
// - Due in the past

const int maxDashboardDueTasks = 5;

class DueTasks extends ConsumerWidget {
  const DueTasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Remove this once the tasks provider is implemented
    // List<Task> tasks = ref.watch(tasksProvider);
    List<Task> tasks = sampleDueTasks;
    tasks = getDueTasks(tasks);

    return TaskList(tasks: tasks);
  }
}

List<Task> getDueTasks(List<Task> tasks) {
  final dueTasks = tasks
      .where(
        (task) =>
            task.dueDate != null && task.dueDate!.isBefore(DateTime.now()),
      )
      .toList();
  dueTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  return dueTasks.take(maxDashboardDueTasks).toList();
}
