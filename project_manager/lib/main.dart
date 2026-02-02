import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:project_manager/app/dependencies.dart'; // Ensures global services/repos are initialized
import 'package:project_manager/pages/create_project/projectcreation.dart';
import 'package:project_manager/themes/app_theme.dart';

// Entry point of the application
void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Manager',
      home: ProjectCreation(),
      theme: AppTheme.lightTheme,
      // TODO: Add dark theme & theme mode
    );
  }
}
