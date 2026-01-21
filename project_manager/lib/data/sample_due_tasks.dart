import 'package:project_manager/models/task.dart';

// This list contains tasks with deadlines only (if it has no deadline, it is not included)

List<Task> sampleDueTasks = [
  Task(
    id: '1',
    name: 'Caffeinate the paper',
    projectId: '1',
    projectName: 'Writing letters',
    dueDate: DateTime(2026, 1, 21),
    status: TaskStatus.pending,
  ),
  Task(
    id: '2',
    name: 'Plan workout routine',
    projectId: '2',
    projectName: 'Wellness',
    dueDate: DateTime(2026, 2, 18),
    status: TaskStatus.inProgress,
  ),
  Task(
    id: '3',
    name: 'Create the dopamine menu',
    projectId: '3',
    projectName: 'Productivity',
    dueDate: DateTime(2026, 1, 21),
    status: TaskStatus.pending,
  ),
  Task(
    id: '4',
    name: 'Create the dopamine menu',
    projectId: '3',
    dueDate: DateTime(2026, 1, 21),
    projectName: 'Productivity',
    status: TaskStatus.completed,
  ),
];
