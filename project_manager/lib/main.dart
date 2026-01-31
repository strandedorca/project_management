import 'package:flutter/material.dart';
import 'package:project_manager/data/repositories/in_memory_project_repository.dart';
import 'package:project_manager/data/repositories/in_memory_task_repository.dart';
import 'package:project_manager/data/services/project_service.dart';
import 'package:project_manager/data/services/task_service.dart';
import 'package:project_manager/pages/create_project/projectcreation.dart';
import 'package:project_manager/themes/app_theme.dart';

// Global instances - shared across the app
// In a real app, use dependency injection (Provider, GetIt, etc.)
final projectRepository = InMemoryProjectRepository();
final taskRepository = InMemoryTaskRepository();

final projectService = ProjectService(projectRepository);
final taskService = TaskService(taskRepository);

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
