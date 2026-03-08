import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/project_providers.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/components/customChip.dart';
import 'package:project_manager/components/optionSwitcher.dart';
import 'package:project_manager/data/sample_statuses.dart';
import 'package:project_manager/pages/dashboard/projectCard.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Project List',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Icon(Icons.arrow_back),
        leadingOnTap: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppDimens.appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusChips(),
            _StatusSwitcher(),
            SizedBox(height: AppDimens.spacingLarge),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimens.spacingMedium),
                  child: ProjectCard(project: projects[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  const _StatusChips();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: defaultStatusNames.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(right: AppDimens.spacingSmall),
          child: CustomChip(
            name: defaultStatusNames[index],
            horizontalPadding: AppDimens.paddingMedium,
            color: Theme.of(context).colorScheme.primary,
            hasBorder: true,
          ),
        ),
      ),
    );
  }
}

class _StatusSwitcher extends StatelessWidget {
  const _StatusSwitcher();
  @override
  Widget build(BuildContext context) {
    return OptionSwitcher(
      options: ['Not Started', 'In Progress'],
      onChanged: (index) {},
    );
  }
}
