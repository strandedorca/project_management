import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/pages/dashboard/projectCardProgress.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';
import 'package:project_manager/utils/number_formatter.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      // clipBehavior is necessary to prevent the InkWell from overflowing the Card
      clipBehavior: Clip.hardEdge,
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
                  children: [
                    Expanded(
                      // ShaderMask (& LinearGradient) to fade out the tags that overflow
                      child: ShaderMask(
                        // SingleChildScrollView > Row pattern to cut off the tags that overflow
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          child: Row(
                            spacing: AppDimens.spacingSmall,
                            children: (project.tags ?? [])
                                .map((tag) => _Tag(tag: tag))
                                .toList(),
                          ),
                        ),
                        shaderCallback: (rect) => const LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.black,
                            Colors.transparent,
                          ],
                          stops: [
                            0.0,
                            0.8, // fade starts at 0.8
                            0.95, // fade ends at 0.9
                          ],
                        ).createShader(rect),
                      ),
                    ),
                    SizedBox(width: AppDimens.spacingSmall),
                    _SingleRadialChart(percentage: project.weight, size: 30),
                  ],
                ),

                // Name
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),

                // Progress
                CardProjectProgress(progress: project.progress),

                // Deadline
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormatter.shortDate(project.deadline),
                    style: Theme.of(context).textTheme.bodySmall,
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

class _Tag extends StatelessWidget {
  final String tag;
  final double tagVerticalPadding = 4.0;
  final double tagHorizontalPadding = 10.0;
  const _Tag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: tagVerticalPadding,
        horizontal: tagHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
      ),
      child: Text(tag, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _SingleRadialChart extends StatelessWidget {
  final double percentage;
  final double size;
  const _SingleRadialChart({required this.percentage, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: percentage / 100,
            color: Theme.of(context).colorScheme.outline,
            backgroundColor: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        Text(
          NumberFormatter.wholeNumber(percentage),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
