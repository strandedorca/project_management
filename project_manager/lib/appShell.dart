import 'package:flutter/material.dart';
import 'package:project_manager/components/customBottomNavBar.dart';
import 'package:project_manager/components/customFAB.dart';
import 'package:project_manager/pages/activities/activities.dart';
import 'package:project_manager/pages/create_project/projectCreation.dart';
import 'package:project_manager/pages/dashboard/dashboard.dart';
import 'package:project_manager/pages/projects/projectList.dart';
import 'package:project_manager/pages/search/search.dart';
import 'package:project_manager/pages/settings/settings.dart';
import 'package:project_manager/pages/tasks/taskCreationModal.dart';
import 'package:project_manager/pages/tasks/tasks.dart';
import 'package:project_manager/pages/upcoming/upcoming.dart';

// Data ----------------------------------------------------------------------
class ActionButton {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

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
    final List<ActionButton> actionButtons = [
      ActionButton(
        icon: Icons.check_circle_outline,
        label: 'New task',
        onTap: () {
          // TODO: Add logic to handle the tap
          TaskCreationModal.showModal(context);
        },
      ),
      ActionButton(
        icon: Icons.folder_open_rounded,
        label: 'New project',
        onTap: () {
          // TODO: Add logic to handle the tap
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProjectCreation()),
          );
        },
      ),
    ];
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_isActionButtonExpanded) toggleActionButton();
          },
          child: Scaffold(
            body: IndexedStack(index: _selectedTab, children: _tabs),
            floatingActionButton: CustomFloatingActionButton(
              isExpanded: _isActionButtonExpanded,
              onTap: toggleActionButton,
              actionButtons: actionButtons,
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedTab: _selectedTab,
              onSwitchTab: (i) {
                setState(() {
                  _selectedTab = i;
                  _isActionButtonExpanded = false;
                });
              },
              onTap: () {
                setState(() {
                  _isActionButtonExpanded = false;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
