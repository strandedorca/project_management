import 'package:project_manager/models/project.dart';

// Sample data
// TODO: Replace with actual data from the database/API/state management
final List<Project> sampleProjects = [
  Project(
    id: '1',
    name: 'Project 1',
    description: 'Description 1',
    type: 'Type 1',
    status: ProjectStatus.ongoing,
    startDate: '2024-01-01',
    endDate: '2024-01-01',
    progress: 0,
    weight: '30',
    color: '0',
    deadline: DateTime.now(),
    tags: ['Tag 1', 'Tag 2'],
  ),
  Project(
    id: '2',
    name: 'Project 2',
    description: 'Description 2',
    type: 'Type 2',
    status: ProjectStatus.notStarted,
    startDate: '2024-01-01',
    endDate: '2024-01-01',
    progress: 0,
    weight: '40',
    color: '0',
    deadline: DateTime.now(),
    tags: ['Tag 3', 'Tag 4', 'Tag 5', 'Tag 6'],
  ),
  Project(
    id: '3',
    name: 'Project 3',
    description: 'Description 3',
    type: 'Type 3',
    status: ProjectStatus.completed,
    startDate: '2024-01-01',
    endDate: '2024-01-01',
    progress: 0,
    weight: '60',
    color: '0',
    deadline: DateTime.now(),
    tags: ['Tag 7', 'Tag 8', 'Tag 9'],
  ),
];
