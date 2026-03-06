import 'package:flutter/material.dart';
import 'package:project_manager/app/dependencies.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/components/customChip.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/data/sample_statuses.dart';
import 'package:project_manager/pages/projects/projectCard.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<Project> _projects = [];

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  void _fetchProjects() {
    setState(() {
      _projects = projectService.getAllProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
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
            ),
            SizedBox(height: AppDimens.spacingLarge),
            Expanded(
              child: ListView.builder(
                itemCount: _projects.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimens.spacingMedium),
                  child: ProjectCard(project: _projects[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
