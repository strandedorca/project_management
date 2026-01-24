import 'package:flutter/material.dart';
import 'package:project_manager/data/sample_upcoming_deadline.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/themes/colors.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';

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

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.35,
        crossAxisSpacing: AppDimens.spacingMedium,
        mainAxisSpacing: AppDimens.spacingMedium,
      ),
      itemBuilder: (context, index) {
        final project = sampleUpcomingDeadlines[index];
        return _DeadlineCard(project: project);
      },
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  final Project project;

  const _DeadlineCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  project.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    DateFormatter.shortDate(project.deadline),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
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
