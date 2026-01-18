import 'package:flutter/material.dart';
import 'package:project_manager/data/sample_upcoming_deadline.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/themes/dimens.dart';

// TODO: Real data from the database/API/state management
class Deadlines extends StatelessWidget {
  const Deadlines({super.key});

  // TODO: Get upcoming deadlines from the database/API/state management (within 1 month and only 4)

  // TODO: Sort by closest deadline

  // TODO: Turn into stateful widget

  @override
  Widget build(BuildContext context) {
    // Limit to 4 items max (or less if fewer exist)
    final itemCount = sampleUpcomingDeadlines.length > 4
        ? 4
        : sampleUpcomingDeadlines.length;

    // TODO: no deadlines
    if (sampleUpcomingDeadlines.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true, // ✅ Auto-calculate height based on content + spacing
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: AppDimens.spacingSmall,
        mainAxisSpacing: AppDimens.spacingSmall,
      ),
      itemBuilder: (context, index) {
        final project = sampleUpcomingDeadlines[index];
        return DeadlineCard(project: project);
      },
    );
  }
}

// TODO: Style card
class DeadlineCard extends StatelessWidget {
  final Project project;

  const DeadlineCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      // Thick border
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        side: BorderSide(width: AppDimens.borderWidthMedium),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to the project details page
          print('Project ${project.name} tapped');
        },
        child: Padding(
          padding: EdgeInsets.all(AppDimens.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(project.name, overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                  DateUtils.dateOnly(project.deadline).toString().split(' ')[0],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: Format deadline date and time utils
// String _formatDeadline(DateTime deadline) {
//   final now = DateTime.now();
//   final difference = deadline.difference(now).inDays;

//   if (difference == 0) {
//     return 'Today';
//   } else if (difference == 1) {
//     return 'Tomorrow';
//   } else if (difference < 7) {
//     return '$difference days';
//   } else {
//     return '${(difference / 7).floor()} weeks';
//   }
// }
