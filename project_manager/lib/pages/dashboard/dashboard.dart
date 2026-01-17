import 'package:flutter/material.dart';
import 'package:project_manager/pages/dashboard/appbar.dart';
import 'package:project_manager/pages/dashboard/projects.dart';
import 'package:project_manager/pages/dashboard/section.dart';
import 'package:project_manager/themes/dimens.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(AppDimens.paddingMedium),
        child: ListView(
          children: [
            Section(body: Projects()),
            SizedBox(height: AppDimens.spacingMedium),
            SizedBox(height: 200, child: Placeholder()),
            SizedBox(height: AppDimens.spacingMedium),
            SizedBox(height: 200, child: Placeholder()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          // TODO: Create a new project
          print('To create a new project');
        },
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }
}
