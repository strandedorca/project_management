import 'package:flutter/material.dart';
import 'package:project_manager/data/sample_due_tasks.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

// Due Tasks section contains a list of tasks that are either:
// - Due today
// - Due in the past

class DueTasks extends StatelessWidget {
  const DueTasks({super.key});

  static const int _rowHeight = 72;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: DecoratedBox(
        decoration: AppDecorations.roundedBorderedBox(
          context,
          AppDimens.borderRadiusSmall,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxRows = constraints.maxHeight ~/ _rowHeight;
            final visibleTasks = sampleDueTasks
                .take(maxRows)
                .toList(growable: false);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final task in visibleTasks)
                  DueTaskTile(
                    task: task,
                    hasBottomBorder: task != visibleTasks.last,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DueTaskTile extends StatelessWidget {
  final Task task;
  final bool hasBottomBorder;
  const DueTaskTile({
    super.key,
    required this.task,
    this.hasBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hasBottomBorder
          ? AppDecorations.bottomBorderedBoxDecoration(context)
          : null,
      child: ListTile(
        title: Text(task.name),
        subtitle: Text(task.projectName),
        leading: Icon(Icons.check_box_outline_blank),
        titleAlignment: ListTileTitleAlignment.top,
        contentPadding: EdgeInsets.symmetric(
          vertical: AppDimens.spacingSmall,
          horizontal: AppDimens.spacingMedium,
        ),
        visualDensity: VisualDensity.compact,
        trailing: Text(
          task.dueDate != null
              ? DateUtils.dateOnly(task.dueDate!).toString().split(' ')[0]
              : 'No deadline',
        ),

        // TODO: add on tap
      ),
    );
  }
}
