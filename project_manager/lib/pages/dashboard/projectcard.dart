import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/providers.dart';
import 'package:project_manager/components/checkboxWithPriority.dart';
import 'package:project_manager/components/customChip.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/pages/projects/projectDetail.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';
import 'package:project_manager/utils/number_formatter.dart';

class ProjectCard extends ConsumerWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? categoryName = ref
        .read(categoryServiceProvider)
        .getCategoryById(project.categoryId)
        ?.name;
    final List<String> tagNames = ref
        .read(tagServiceProvider)
        .getTagsByIds(project.tags ?? [])
        .map((tag) => tag.name)
        .toList();

    return Card(
      margin: EdgeInsets.zero,
      // clipBehavior is necessary to prevent the InkWell from overflowing the Card
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        side: BorderSide(width: AppDimens.borderWidthMedium),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProjectDetail(project: project),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(AppDimens.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags & Weight/Priority
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _ScrollableTags(
                      category: categoryName ?? '',
                      tags: tagNames,
                    ),
                  ),
                  SizedBox(width: AppDimens.spacingSmall),
                  project.weight != null
                      ? _SingleRadialChart(
                          percentage: project.weight!,
                          size: 30,
                        )
                      : CheckboxWithPriority(
                          priority: project.priority,
                          size: 30,
                          borderWidth: 4,
                          isChecked: false,
                        ),
                ],
              ),
              SizedBox(height: AppDimens.spacingSmall),
              // Name
              Text(
                project.name,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppDimens.spacingSmall),
              // Progress
              // CardProjectProgress(progress: project.progress),
              // SizedBox(height: AppDimens.spacingSmall),
              // Deadline
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  project.deadline != null
                      ? DateFormatter.shortDate(project.deadline!)
                      : 'No deadline',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollableTags extends StatelessWidget {
  final String category;
  final List<String> tags;
  const _ScrollableTags({required this.category, required this.tags});

  @override
  Widget build(BuildContext context) {
    // ShaderMask (& LinearGradient) to fade out the tags that overflow
    return ShaderMask(
      // SingleChildScrollView > Row pattern to cut off the tags that overflow
      // SingleChildScrollView is necessary to avoid overflowing
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Row(
          spacing: AppDimens.spacingSmall,
          children: ([category, ...tags])
              .map(
                (tag) => CustomChip(
                  name: tag,
                  color: Theme.of(context).colorScheme.outlineVariant,
                  verticalPadding: 4.0,
                  horizontalPadding: 10.0,
                  borderRadius: tag == category
                      ? AppDimens.borderRadiusSmall
                      : null,
                ),
              )
              .toList(),
        ),
      ),
      shaderCallback: (rect) => const LinearGradient(
        colors: [Colors.black, Colors.black, Colors.transparent],
        stops: [
          0.0,
          0.8, // fade starts at 0.8
          0.95, // fade ends at 0.9
        ],
      ).createShader(rect),
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
