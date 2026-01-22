import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/pages/dashboard/appbar.dart';
import 'package:project_manager/pages/dashboard/deadlines.dart';
import 'package:project_manager/pages/dashboard/duetasks.dart';
import 'package:project_manager/pages/dashboard/projects.dart';
import 'package:project_manager/pages/dashboard/section.dart';
import 'package:project_manager/services/user_service.dart';
import 'package:project_manager/themes/dimens.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});
  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Create an instance of the UserService
  final UserService _userService = UserService();
  User? _user;

  // Runs once only when the widget is first created
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // Fetch user
    final user = await _userService.getCurrentUser();
    // Update state
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: _user),
      body: Padding(
        padding: EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          children: [
            Section(body: Projects(), title: 'Ongoing Projects'),
            SizedBox(height: AppDimens.spacingMedium),
            Section(body: Deadlines(), title: 'Upcoming Deadlines'),
            SizedBox(height: AppDimens.spacingMedium),
            Expanded(
              child: Section(body: DueTasks(), title: 'Due Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
