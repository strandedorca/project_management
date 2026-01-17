import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/pages/dashboard/progress.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      // clipBehavior is necessary to prevent the InkWell from overflowing the Card
      clipBehavior: Clip.hardEdge,
      // Thick border
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        side: BorderSide(width: AppDimens.borderWidthMedium),
      ),
      // InkWell is a clickable widget that allows tapping
      child: InkWell(
        onTap: () {
          // TODO: Navigate to the project details page
          print('Project ${project.name} tapped');
        },
        child: SizedBox(
          height: 200,
          width: 300,
          child: Padding(
            padding: EdgeInsets.all(AppDimens.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags & Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // TODO: Style Chips
                  // TODO: Style weight
                  // TODO: make wrap cut off and fade out
                  children: [
                    Expanded(
                      child: ClipRect(
                        child: Stack(
                          children: [
                            // Tags row - single line, can overflow
                            Row(
                              children: (project.tags ?? [])
                                  .map(
                                    (tag) => Padding(
                                      padding: EdgeInsets.only(
                                        right: AppDimens.spacingSmall,
                                      ),
                                      child: Chip(label: Text(tag)),
                                    ),
                                  )
                                  .toList(),
                            ),
                            // Fade gradient overlay on the right
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: IgnorePointer(
                                child: Container(
                                  width: 30, // Fade width
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        Theme.of(context).cardColor,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.spacingSmall),
                    Text(project.weight),
                  ],
                ),

                // Name
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Progress
                ProgressBar(progress: project.progress),
                // Deadline
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateUtils.dateOnly(
                      project.deadline,
                    ).toString().split(' ')[0],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
