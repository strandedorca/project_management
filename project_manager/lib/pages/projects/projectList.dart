import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/project_providers.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/components/customChip.dart';
import 'package:project_manager/data/sample_statuses.dart';
import 'package:project_manager/pages/dashboard/projectCard.dart';
import 'package:project_manager/pages/projects/fullWidthSwitcher.dart';
import 'package:project_manager/themes/dimens.dart';

enum Tab {
  all(0, 'all'),
  onGoing(1, 'ongoing'),
  notStarted(2, 'not_started'),
  completed(3, 'completed');

  final int i;
  final String value;

  const Tab(this.i, this.value);
}

class ProjectList extends ConsumerStatefulWidget {
  const ProjectList({super.key});

  @override
  ConsumerState<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends ConsumerState<ProjectList> {
  Tab _selectedTab = Tab.all;

  void handleTabSwitch(int index) {
    setState(() {
      _selectedTab = Tab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final filteredProjects = projects
        .where(
          (project) => _selectedTab == Tab.all
              ? true
              : project.status.value == _selectedTab.value,
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
            SizedBox(height: AppDimens.spacingLarge),
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
      options: ['All', 'Not Started', 'Ongoing', 'Completed'],
      onChanged: (index) => onTabSwitch(index),
    );
  }
}
