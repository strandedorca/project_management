import 'package:flutter/material.dart';
import 'package:project_manager/data/sample_data.dart';
import 'package:project_manager/pages/dashboard/projectcard.dart';
import 'package:project_manager/themes/dimens.dart';

class Projects extends StatelessWidget {
  const Projects({super.key});

  // TODO: Real data from the database/API/state management
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // ListView needs a bounded height before rendering children
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: sampleProjects.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: AppDimens.spacingMedium),
          child: ProjectCard(project: sampleProjects[index]),
        ),
      ),
    );
  }
}
