import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/data/models/status.dart';

// Sample data
// TODO: Replace with actual data from the database/API/state management
final List<Project> sampleProjects = [
  Project(
    id: '1',
    name: 'Conceptual Modelling',
    description: 'Description 1',
    categoryId: '1',
    status: ProjectStatus.onGoing,
    priority: PriorityLevel.no,
    deadline: DateTime.now(),
    tags: ['2', '1'],
    updatedAt: DateTime.now(),
  ),
  Project(
    id: '2',
    name: 'Renaissance Period Essay',
    description: 'Description 2',
    categoryId: '2',
    status: ProjectStatus.notStarted,
    priority: PriorityLevel.no,
    deadline: DateTime.now(),
    tags: ['2', '3', '4', '5'],
    updatedAt: DateTime.now(),
  ),
  Project(
    id: '3',
    name: 'Standardisation',
    description: 'Description 3',
    categoryId: '3',
    status: ProjectStatus.completed,
    priority: PriorityLevel.no,
    deadline: DateTime.now(),
    tags: ['2', '4'],
    updatedAt: DateTime.now(),
  ),
];
