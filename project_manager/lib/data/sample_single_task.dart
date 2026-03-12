import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/data/models/task.dart';

// This list contains tasks with deadlines only (if it has no deadline, it is not included)

List<Task> sampleSingleTasks = [
  Task(
    id: '1',
    name: 'Caffeinate the paper',
    parentId: '1',
    dueDate: DateTime(2026, 1, 21),
    status: Status.pending,
    updatedAt: DateTime.now(),
    priority: PriorityLevel.medium,
  ),
  // Task(
  //   id: '2',
  //   name: 'Plan workout routine & calorie intake',
  //   parentId: '2',
  //   dueDate: DateTime(2026, 1, 14),
  //   status: Status.onGoing,
  //   updatedAt: DateTime.now(),
  //   priority: PriorityLevel.medium,
  // ),
  // Task(
  //   id: '3',
  //   name: 'Create the dopamine menu',
  //   parentId: '3',
  //   dueDate: DateTime(2026, 1, 24),
  //   status: Status.pending,
  //   updatedAt: DateTime.now(),
  //   priority: PriorityLevel.medium,
  // ),
  // Task(
  //   id: '4',
  //   name:
  //       'Create the dopamine menu that is really long and will overflow the container',
  //   parentId: '3',
  //   dueDate: DateTime(2026, 1, 24),
  //   status: Status.completed,
  //   updatedAt: DateTime.now(),
  //   priority: PriorityLevel.medium,
  // ),
  // Task(
  //   id: '5',
  //   name: 'Practice the piano',
  //   parentId: '3',
  //   dueDate: DateTime(2026, 1, 23),
  //   status: Status.pending,
  //   updatedAt: DateTime.now(),
  //   priority: PriorityLevel.medium,
  // ),
];
