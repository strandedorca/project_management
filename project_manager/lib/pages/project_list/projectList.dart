import 'package:flutter/material.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/components/customChip.dart';
import 'package:project_manager/data/sample_data.dart';
import 'package:project_manager/data/sample_statuses.dart';
import 'package:project_manager/pages/dashboard/projectCard.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  itemCount: sampleProjects.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.spacingMedium),
                    child: ProjectCard(project: sampleProjects[index]),
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
