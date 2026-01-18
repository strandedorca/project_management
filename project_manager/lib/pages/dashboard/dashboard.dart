import 'package:flutter/material.dart';
import 'package:project_manager/pages/dashboard/appbar.dart';
import 'package:project_manager/pages/dashboard/deadlines.dart';
import 'package:project_manager/pages/dashboard/duetasks.dart';
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
        child: Column(
          children: [
            Section(body: Projects(), title: 'Ongoing Projects'),
            SizedBox(height: AppDimens.spacingMedium),
            Section(body: Deadlines(), title: 'Upcoming Deadlines'),
            SizedBox(height: AppDimens.spacingMedium),
            Section(body: DueTasks(), title: 'Due Tasks'),
          ],
        ),
      ),
    );
  }
}
