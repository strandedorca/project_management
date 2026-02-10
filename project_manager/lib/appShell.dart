import 'package:flutter/material.dart';
import 'package:project_manager/components/customBottomNavBar.dart';
import 'package:project_manager/components/customFAB.dart';
import 'package:project_manager/pages/activities/activities.dart';
import 'package:project_manager/pages/dashboard/dashboard.dart';
import 'package:project_manager/pages/projects/projectList.dart';
import 'package:project_manager/pages/search/search.dart';
import 'package:project_manager/pages/settings/settings.dart';
import 'package:project_manager/pages/tasks/tasks.dart';
import 'package:project_manager/pages/upcoming/upcoming.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedTab = 0;
  bool _isActionButtonExpanded = false;

  void toggleActionButton() {
    setState(() => _isActionButtonExpanded = !_isActionButtonExpanded);
  }

  final _tabs = const [
    Dashboard(title: 'Dashboard'),
    ProjectList(),
    Tasks(),
    Upcoming(),
    Search(),
    Activities(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_isActionButtonExpanded) toggleActionButton();
            },
            child: IndexedStack(index: _selectedTab, children: _tabs),
          ),
          floatingActionButton: CustomFloatingActionButton(
            isExpanded: _isActionButtonExpanded,
            onTap: toggleActionButton,
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedTab: _selectedTab,
            onTap: (i) {
              setState(() {
                _selectedTab = i;
                _isActionButtonExpanded = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
