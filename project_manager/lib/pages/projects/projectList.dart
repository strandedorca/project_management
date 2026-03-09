import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/projects_provider.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/components/customChip.dart';
import 'package:project_manager/data/sample_statuses.dart';
import 'package:project_manager/pages/dashboard/projectCard.dart';
import 'package:project_manager/pages/projects/fullWidthSwitcher.dart';
import 'package:project_manager/themes/dimens.dart';

enum StatusFilter {
  all('all', 'All'),
  notStarted('not_started', 'Not Started'),
  onGoing('ongoing', 'Ongoing'),
  completed('completed', 'Completed');

  final String value;
  final String label;

  const StatusFilter(this.value, this.label);
}

class ProjectList extends ConsumerStatefulWidget {
  const ProjectList({super.key});

  @override
  ConsumerState<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends ConsumerState<ProjectList> {
  StatusFilter _selectedStatusFilter = StatusFilter.all;

  void handleTabSwitch(int index) {
    setState(() {
      _selectedStatusFilter = StatusFilter.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final filteredProjects = projects
        .where(
          (project) => _selectedStatusFilter == StatusFilter.all
              ? true
              : project.status.value == _selectedStatusFilter.value,
        )
        .toList();

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
            _TabSwitcher(onTabSwitch: handleTabSwitch),
            const SizedBox(height: AppDimens.spacingLarge),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimens.spacingMedium),
                  child: ProjectCard(project: filteredProjects[index]),
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

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.onTabSwitch});

  final ValueChanged<int> onTabSwitch;

  @override
  Widget build(BuildContext context) {
    return FullWidthSwitcher(
      options: StatusFilter.values
          .map((statusFilter) => statusFilter.label)
          .toList(),
      onChanged: (index) => onTabSwitch(index),
    );
  }
}
