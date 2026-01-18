# Model Usage Examples

## Creating a Project

```dart
import 'package:project_manager/models/project.dart';

// Create a new project
final project = Project(
  id: '1', // In real app, generate unique ID (use uuid package)
  name: 'Build Mobile App',
  description: 'Create a Flutter app for project management',
  deadline: DateTime(2024, 12, 31), // December 31, 2024
  status: ProjectStatus.notStarted,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

**Key Points:**

- All required fields must be provided
- `description` is optional (can be `null`)
- Use `DateTime.now()` for timestamps
- Use `ProjectStatus` enum (not a string!)

## Creating a Task

```dart
import 'package:project_manager/models/task.dart';

// Create a new task
final task = Task(
  id: '1',
  name: 'Design login screen',
  description: 'Create wireframes and mockups',
  projectId: '1', // Must match a project's ID
  dueDate: DateTime(2024, 11, 15), // Optional - can be null
  status: TaskStatus.pending,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Task without due date
final taskNoDeadline = Task(
  id: '2',
  name: 'Research best practices',
  description: null, // Optional
  projectId: '1',
  dueDate: null, // No deadline
  status: TaskStatus.pending,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

**Key Points:**

- `projectId` must match an existing project's ID
- `dueDate` is optional (can be `null`)
- `description` is optional

## Updating a Project (Using copyWith)

```dart
// Original project
final project = Project(
  id: '1',
  name: 'Build Mobile App',
  deadline: DateTime(2024, 12, 31),
  status: ProjectStatus.notStarted,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Update project name and status
final updatedProject = project.copyWith(
  name: 'Build Mobile App v2',
  status: ProjectStatus.ongoing,
  // updatedAt is automatically set to DateTime.now()
);

// Update only deadline
final projectWithNewDeadline = project.copyWith(
  deadline: DateTime(2025, 1, 15),
);
```

**Key Points:**

- `copyWith()` creates a NEW instance (original is unchanged)
- Fields you don't specify keep their old values
- `updatedAt` is automatically updated

## Updating a Task

```dart
// Mark task as completed
final completedTask = task.copyWith(
  status: TaskStatus.completed,
);

// Update task name and due date
final updatedTask = task.copyWith(
  name: 'Design login and signup screens',
  dueDate: DateTime(2024, 11, 20),
);
```

## Using Helper Methods

```dart
// Check if project is overdue
if (project.isOverdue) {
  print('Project is overdue!');
}

// Get days until deadline
final daysLeft = project.daysUntilDeadline;
if (daysLeft < 0) {
  print('Overdue by ${-daysLeft} days');
} else {
  print('$daysLeft days until deadline');
}

// Check if task is completed
if (task.isCompleted) {
  print('Task is done!');
}

// Check if task is overdue
if (task.isOverdue) {
  print('Task is overdue!');
}

// Get days until task due date
final daysUntilDue = task.daysUntilDue;
if (daysUntilDue == null) {
  print('No due date set');
} else if (daysUntilDue < 0) {
  print('Overdue by ${-daysUntilDue} days');
} else {
  print('$daysUntilDue days until due');
}
```

## Working with Lists

```dart
// List of projects
final List<Project> projects = [
  Project(
    id: '1',
    name: 'Project 1',
    deadline: DateTime(2024, 12, 31),
    status: ProjectStatus.ongoing,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Project(
    id: '2',
    name: 'Project 2',
    deadline: DateTime(2025, 1, 15),
    status: ProjectStatus.notStarted,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

// Filter: Get only ongoing projects
final ongoingProjects = projects.where(
  (project) => project.status == ProjectStatus.ongoing,
).toList();

// Filter: Get projects due in next 7 days
final upcomingDeadlines = projects.where(
  (project) {
    final daysUntil = project.daysUntilDeadline;
    return daysUntil >= 0 && daysUntil <= 7;
  },
).toList();

// Sort: By deadline (soonest first)
projects.sort((a, b) => a.deadline.compareTo(b.deadline));

// Find: Get project by ID
final project = projects.firstWhere(
  (p) => p.id == '1',
);

// Count: How many ongoing projects?
final ongoingCount = projects.where(
  (p) => p.status == ProjectStatus.ongoing,
).length;
```

## Working with Tasks

```dart
// List of tasks for a project
final List<Task> tasks = [
  Task(
    id: '1',
    name: 'Task 1',
    projectId: '1',
    status: TaskStatus.pending,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Task(
    id: '2',
    name: 'Task 2',
    projectId: '1',
    status: TaskStatus.completed,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

// Filter: Get tasks for a specific project
final projectTasks = tasks.where(
  (task) => task.projectId == '1',
).toList();

// Filter: Get completed tasks
final completedTasks = tasks.where(
  (task) => task.isCompleted,
).toList();

// Filter: Get due tasks (next 7 days)
final dueTasks = tasks.where(
  (task) {
    if (task.dueDate == null) return false;
    final daysUntil = task.daysUntilDue;
    return daysUntil != null && daysUntil >= 0 && daysUntil <= 7;
  },
).toList();

// Calculate progress: percentage of completed tasks
final totalTasks = tasks.length;
final completedCount = tasks.where((t) => t.isCompleted).length;
final progress = totalTasks > 0 ? (completedCount / totalTasks) * 100 : 0.0;
```

## Common Patterns

### Creating Project with Tasks

```dart
// 1. Create project
final project = Project(
  id: '1',
  name: 'Build Mobile App',
  deadline: DateTime(2024, 12, 31),
  status: ProjectStatus.notStarted,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// 2. Create tasks for the project
final tasks = [
  Task(
    id: '1',
    name: 'Design UI',
    projectId: project.id, // Link to project
    status: TaskStatus.pending,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Task(
    id: '2',
    name: 'Build backend',
    projectId: project.id,
    status: TaskStatus.pending,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
```

### Generating Unique IDs

```dart
// Simple approach (for MVP)
int _nextProjectId = 1;
int _nextTaskId = 1;

String generateProjectId() {
  return (_nextProjectId++).toString();
}

String generateTaskId() {
  return (_nextTaskId++).toString();
}

// Better approach (use uuid package)
// Add to pubspec.yaml: uuid: ^4.0.0
import 'package:uuid/uuid.dart';

final uuid = Uuid();

final projectId = uuid.v4(); // Generates unique ID like "550e8400-e29b-41d4-a716-446655440000"
```

## Common Mistakes to Avoid

### ❌ Wrong: Using String for Status

```dart
// Don't do this
final status = 'ongoing'; // Can have typos!
```

### ✅ Right: Using Enum

```dart
// Do this
final status = ProjectStatus.ongoing; // Type-safe!
```

### ❌ Wrong: Storing Dates as Strings

```dart
// Don't do this
final deadline = '2024-12-31'; // Can't do date math!
```

### ✅ Right: Using DateTime

```dart
// Do this
final deadline = DateTime(2024, 12, 31); // Can calculate days until!
```

### ❌ Wrong: Modifying Immutable Models

```dart
// Don't do this - won't compile!
project.name = 'New Name'; // Error: can't modify final field
```

### ✅ Right: Using copyWith

```dart
// Do this
final updated = project.copyWith(name: 'New Name');
```

## Next Steps

1. **Practice:** Create some sample projects and tasks
2. **Experiment:** Try filtering, sorting, updating
3. **Build:** Use these models in your state management
4. **Learn:** Understand why models are designed this way
