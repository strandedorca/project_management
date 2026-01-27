import 'package:flutter/material.dart';
import 'package:project_manager/components/customAppbar.dart';

class ProjectCreationScreen extends StatelessWidget {
  const ProjectCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Create New Project',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Icon(Icons.arrow_back),
      ),
      body: Column(children: [Text('Create Project')]),
    );
  }
}
