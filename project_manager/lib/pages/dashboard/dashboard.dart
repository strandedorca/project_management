import 'package:flutter/material.dart';
import 'package:project_manager/data/models/user.dart';
import 'package:project_manager/data/services/user_service.dart';
import 'package:project_manager/pages/dashboard/dashboardAppbar.dart';
import 'package:project_manager/pages/dashboard/deadlines.dart';
import 'package:project_manager/pages/dashboard/dueTasks.dart';
import 'package:project_manager/pages/dashboard/projects.dart';
import 'package:project_manager/pages/dashboard/section.dart';
import 'package:project_manager/themes/dimens.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});
  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final UserService _userService = UserService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _userService.getCurrentUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Scaffold(
        appBar: DashboardAppbar(user: _user),
        body: Padding(
          padding: EdgeInsets.only(
            top: AppDimens.appPadding,
            left: AppDimens.appPadding,
            right: AppDimens.appPadding,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppDimens.appPadding),
              child: Column(
                children: [
                  Section(body: Projects(), title: 'Ongoing Projects'),
                  SizedBox(height: AppDimens.spacingMedium),
                  Section(body: Deadlines(), title: 'Upcoming Deadlines'),
                  SizedBox(height: AppDimens.spacingMedium),
                  Section(body: DueTasks(), title: 'Due Tasks'),
                  SizedBox(height: AppDimens.spacingLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
