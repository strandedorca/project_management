import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/projects_provider.dart';
import 'package:project_manager/app/tasks_provider.dart';
import 'package:project_manager/components/checkboxWithPriority.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/data/models/task.dart';
import 'package:project_manager/pages/tasks/taskCreationModal.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final sortedTasks = List<Task>.from(tasks)
      ..sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });

    return DecoratedBox(
      decoration: AppDecorations.roundedBorderedBox(
        context,
        AppDimens.borderRadiusSmall,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final task in sortedTasks)
            Consumer(
              builder: (context, ref, child) {
                return _TaskTile(
                  task: task,
                  hasBottomBorder: task != sortedTasks.last,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  final Task task;
  final bool hasBottomBorder;

  const _TaskTile({required this.task, this.hasBottomBorder = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateColor = isTodayOrAfter(task.dueDate)
        ? Theme.of(context).colorScheme.outline
        : Theme.of(context).colorScheme.error;
    final displayedDueDate = task.dueDate != null
        ? DateFormatter.shortDateNoYearRelativeToToday(task.dueDate!)
        : null;
    final projectName = ref.watch(projectNameProvider(task.parentId));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('Task ${task.name} tapped');
          TaskCreationModal.showModal(context, task: task);
        },
        child: Container(
          decoration: hasBottomBorder
              ? AppDecorations.bottomBorderedBoxDecoration(context)
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              InkWell(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () {
                  print('Checkbox tapped');
                  if (task.status == Status.completed) {
                    ref.read(tasksProvider.notifier).reopenTask(task.id);
                  } else {
                    ref.read(tasksProvider.notifier).completeTask(task.id);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(
                    AppDimens.paddingMedium,
                  ).copyWith(top: AppDimens.paddingMedium + 2),
                  child: CheckboxWithPriority(
                    priority: task.priority,
                    size: AppDimens.iconCheckboxSize,
                    borderWidth: 2.5,
                    isChecked: task.status == Status.completed,
                  ),
                ),
              ),

              // Task name and project name
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: AppDimens.paddingMedium,
                    top: AppDimens.paddingMedium,
                    bottom: AppDimens.paddingMedium,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.name, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(
                              projectName ?? 'No project',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Due date
                      Text(
                        displayedDueDate ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: dateColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isTodayOrAfter(DateTime? date) {
  if (date == null) return false;
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  return !date.isBefore(today);
}
