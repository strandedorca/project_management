import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/data/models/status.dart';

// Sample data
// TODO: Replace with actual data from the database/API/state management
final List<Project> sampleUpcomingDeadlines = [
  Project(
    id: '1',
    name: 'Programming Quiz',
    description: 'Description 1',
    categoryId: '1',
    status: Status.onGoing,
    priority: PriorityLevel.no,
    deadline: DateTime.now(),
    tags: ['Tag 1', 'Tag 2'],
    updatedAt: DateTime.now(),
  ),
  Project(
    id: '2',
    name: 'Conceptual Modelling',
    description: 'Description 2',
    categoryId: '2',
    status: Status.pending,
    priority: PriorityLevel.no,
    deadline: DateTime.now(),
    tags: ['Tag 3', 'Tag 4', 'Tag 5', 'Tag 6'],
    updatedAt: DateTime.now(),
  ),
  Project(
    id: '3',
    name: 'Standardisation Task',
    description: 'Description 3',
    categoryId: '3',
    status: Status.pending,
    priority: PriorityLevel.no,
    deadline: DateTime.now(),
    tags: ['Tag 7', 'Tag 8', 'Tag 9'],
    updatedAt: DateTime.now(),
  ),
  Project(
    id: '4',
    name: 'Cyber Hygiene Assignment',
    description: 'Description 4',
    categoryId: '4',
    status: Status.onGoing,
    priority: PriorityLevel.no,
    deadline: DateTime.now(),
    tags: ['Tag 10', 'Tag 11', 'Tag 12'],
    updatedAt: DateTime.now(),
  ),
];
