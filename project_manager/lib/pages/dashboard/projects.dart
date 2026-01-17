import 'package:flutter/material.dart';
import 'package:project_manager/data/sample_data.dart';
import 'package:project_manager/pages/dashboard/projectcard.dart';

class Projects extends StatelessWidget {
  const Projects({super.key});

  // TODO: Real data from the database/API/state management
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // ListView needs a bounded height before rendering children
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sampleProjects.length,
        itemBuilder: (context, index) =>
            ProjectCard(project: sampleProjects[index]),
      ),
    );
  }
}
