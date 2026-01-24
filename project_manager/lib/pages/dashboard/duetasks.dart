import 'package:flutter/material.dart';
import 'package:project_manager/components/checkbox.dart';
import 'package:project_manager/data/sample_due_tasks.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';

// Due Tasks section contains a list of tasks that are either:
// - Due today
// - Due in the past

class DueTasks extends StatelessWidget {
  const DueTasks({super.key});

  @override
  Widget build(BuildContext context) {
    List<Task> visibleTasks = List<Task>.from(sampleDueTasks)
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    visibleTasks = visibleTasks.take(5).toList();

    return DecoratedBox(
      decoration: AppDecorations.roundedBorderedBox(
        context,
        AppDimens.borderRadiusSmall,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final task in visibleTasks)
            _DueTaskTile(
              task: task,
              hasBottomBorder: task != visibleTasks.last,
            ),
        ],
      ),
    );
  }
}

class _DueTaskTile extends StatelessWidget {
  final Task task;
  final bool hasBottomBorder;

  const _DueTaskTile({required this.task, this.hasBottomBorder = true});

  @override
  Widget build(BuildContext context) {
    final displayedDueDate = DateFormatter.shortDateNoYearRelativeToToday(
      task.dueDate!,
    );
    return Container(
      decoration: hasBottomBorder
          ? AppDecorations.bottomBorderedBoxDecoration(context)
          : null,
      child: Padding(
        padding: EdgeInsets.all(AppDimens.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: CustomCheckbox(size: AppDimens.iconSmall),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.name, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    task.projectName.isEmpty ? 'No project' : task.projectName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              displayedDueDate,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: displayedDueDate == 'Today'
                    ? Theme.of(context).colorScheme.outline
                    : Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
