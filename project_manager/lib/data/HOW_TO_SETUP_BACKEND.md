# How to Setup Your "Backend" - Step by Step

## What You're Building

Your "backend" is actually just a **data layer** inside your Flutter app. It's the part that:
- Stores projects and tasks in memory
- Provides methods to create/read/update/delete
- Keeps your UI separate from data storage

**Why separate?** Later you can swap in-memory storage for a database without changing your UI code!

---

## Step 1: Create Repository Interfaces

**What:** Abstract classes that define what operations you can do.

**Why first?** Defines the contract - "I need these methods, I don't care how they're implemented"

**File:** `lib/data/repositories/project_repository.dart`

```dart
import 'package:project_manager/models/project.dart';

/// Abstract interface for project storage
/// 
/// **What is abstract?**
/// - Defines what methods exist, but not how they work
/// - Like a contract: "Any project storage must have these methods"
/// 
/// **Why abstract?**
/// - Can swap implementations later (in-memory → database → API)
/// - UI doesn't care HOW data is stored, just WHAT operations are available
abstract class ProjectRepository {
  /// Get all projects
  /// Returns: List of all projects
  List<Project> getAll();
  
  /// Get a single project by ID
  /// Returns: Project if found, null if not found
  Project? getById(String id);
  
  /// Create a new project
  /// Returns: The created project (with ID assigned)
  Project create(Project project);
  
  /// Update an existing project
  /// Returns: The updated project
  Project update(Project project);
  
  /// Delete a project by ID
  /// Returns: true if deleted, false if not found
  bool delete(String id);
}
```

**File:** `lib/data/repositories/task_repository.dart`

```dart
import 'package:project_manager/models/task.dart';

/// Abstract interface for task storage
abstract class TaskRepository {
  /// Get all tasks
  List<Task> getAll();
  
  /// Get tasks for a specific project
  /// This is the most common query - "show me all tasks for project X"
  List<Task> getByProjectId(String projectId);
  
  /// Get a single task by ID
  Task? getById(String id);
  
  /// Create a new task
  Task create(Task task);
  
  /// Update an existing task
  Task update(Task task);
  
  /// Delete a task by ID
  bool delete(String id);
}
```

---

## Step 2: Implement In-Memory Repositories

**What:** Actual implementations that store data in a List (in memory).

**Why this approach?** Simplest possible implementation - just uses Dart Lists.

**File:** `lib/data/repositories/in_memory_project_repository.dart`

```dart
import 'package:project_manager/models/project.dart';
import 'package:project_manager/data/repositories/project_repository.dart';

/// In-memory implementation of ProjectRepository
/// 
/// **How it works:**
/// - Stores projects in a List
/// - All operations work on this list
/// - Data is lost when app closes (OK for MVP!)
class InMemoryProjectRepository implements ProjectRepository {
  // Private list - only this class can modify directly
  final List<Project> _projects = [];
  
  /// Get all projects
  /// Returns a COPY of the list (prevents external modification)
  @override
  List<Project> getAll() {
    return List.from(_projects); // Copy, not original
  }
  
  /// Get project by ID
  /// Uses firstWhere with orElse to find or return null
  @override
  Project? getById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null; // Not found
    }
  }
  
  /// Create new project
  /// Just adds it to the list!
  @override
  Project create(Project project) {
    _projects.add(project);
    return project;
  }
  
  /// Update existing project
  /// Finds old project, replaces it with new one
  @override
  Project update(Project updatedProject) {
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index == -1) {
      throw Exception('Project not found: ${updatedProject.id}');
    }
    _projects[index] = updatedProject;
    return updatedProject;
  }
  
  /// Delete project by ID
  /// Removes from list if found
  @override
  bool delete(String id) {
    final index = _projects.indexWhere((p) => p.id == id);
    if (index == -1) {
      return false; // Not found
    }
    _projects.removeAt(index);
    return true;
  }
}
```

**File:** `lib/data/repositories/in_memory_task_repository.dart`

```dart
import 'package:project_manager/models/task.dart';
import 'package:project_manager/data/repositories/task_repository.dart';

/// In-memory implementation of TaskRepository
class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];
  
  @override
  List<Task> getAll() {
    return List.from(_tasks);
  }
  
  /// Get tasks for a specific project
  /// This is the key method - filters by projectId
  @override
  List<Task> getByProjectId(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }
  
  @override
  Task? getById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Task create(Task task) {
    _tasks.add(task);
    return task;
  }
  
  @override
  Task update(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index == -1) {
      throw Exception('Task not found: ${updatedTask.id}');
    }
    _tasks[index] = updatedTask;
    return updatedTask;
  }
  
  @override
  bool delete(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) {
      return false;
    }
    _tasks.removeAt(index);
    return true;
  }
}
```

---

## Step 3: Create a Service/Controller Layer (Optional but Recommended)

**What:** A layer that wraps repositories and provides business logic.

**Why?** Keeps UI simple - UI calls service, service handles repository calls.

**File:** `lib/data/services/project_service.dart`

```dart
import 'package:project_manager/models/project.dart';
import 'package:project_manager/data/repositories/project_repository.dart';

/// Service layer for projects
/// 
/// **What it does:**
/// - Wraps repository calls
/// - Adds business logic (validation, ID generation, etc.)
/// - Makes it easier for UI to use
class ProjectService {
  final ProjectRepository _repository;
  
  /// Constructor - takes repository as dependency
  /// This is "dependency injection" - service doesn't care which implementation
  ProjectService(this._repository);
  
  /// Get all projects
  List<Project> getAllProjects() {
    return _repository.getAll();
  }
  
  /// Get project by ID
  Project? getProjectById(String id) {
    return _repository.getById(id);
  }
  
  /// Create project with auto-generated ID
  /// Business logic: Generate ID, set timestamps
  Project createProject({
    required String name,
    String? description,
    required DateTime deadline,
    ProjectStatus status = ProjectStatus.notStarted,
  }) {
    // Generate ID (simple counter for MVP)
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final now = DateTime.now();
    
    final project = Project(
      id: id,
      name: name,
      description: description,
      deadline: deadline,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    
    return _repository.create(project);
  }
  
  /// Update project
  Project updateProject(Project project) {
    final updated = project.copyWith(updatedAt: DateTime.now());
    return _repository.update(updated);
  }
  
  /// Delete project
  bool deleteProject(String id) {
    return _repository.delete(id);
  }
  
  /// Business logic: Get ongoing projects
  List<Project> getOngoingProjects() {
    return _repository.getAll()
        .where((p) => p.status == ProjectStatus.ongoing)
        .toList();
  }
  
  /// Business logic: Get upcoming deadlines (next 7 days)
  List<Project> getUpcomingDeadlines() {
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(Duration(days: 7));
    
    return _repository.getAll()
        .where((p) => p.deadline.isAfter(now) && p.deadline.isBefore(sevenDaysFromNow))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }
}
```

**File:** `lib/data/services/task_service.dart`

```dart
import 'package:project_manager/models/task.dart';
import 'package:project_manager/data/repositories/task_repository.dart';

/// Service layer for tasks
class TaskService {
  final TaskRepository _repository;
  
  TaskService(this._repository);
  
  /// Get all tasks for a project
  List<Task> getTasksForProject(String projectId) {
    return _repository.getByProjectId(projectId);
  }
  
  /// Create task with auto-generated ID
  Task createTask({
    required String name,
    String? description,
    required String projectId,
    DateTime? dueDate,
    TaskStatus status = TaskStatus.pending,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();
    
    final task = Task(
      id: id,
      name: name,
      description: description,
      projectId: projectId,
      dueDate: dueDate,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    
    return _repository.create(task);
  }
  
  /// Update task
  Task updateTask(Task task) {
    final updated = task.copyWith(updatedAt: DateTime.now());
    return _repository.update(updated);
  }
  
  /// Mark task as completed
  Task completeTask(String taskId) {
    final task = _repository.getById(taskId);
    if (task == null) {
      throw Exception('Task not found: $taskId');
    }
    return updateTask(task.copyWith(
      status: TaskStatus.completed,
    ));
  }
  
  /// Delete task
  bool deleteTask(String id) {
    return _repository.delete(id);
  }
  
  /// Get due tasks (next 7 days, not completed)
  List<Task> getDueTasks() {
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(Duration(days: 7));
    
    return _repository.getAll()
        .where((task) {
          if (task.dueDate == null) return false;
          if (task.status == TaskStatus.completed) return false;
          return task.dueDate!.isAfter(now) && 
                 task.dueDate!.isBefore(sevenDaysFromNow);
        })
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }
}
```

---

## Step 4: Wire It All Together

**File:** `lib/main.dart` (or create a separate setup file)

```dart
import 'package:flutter/material.dart';
import 'package:project_manager/data/repositories/in_memory_project_repository.dart';
import 'package:project_manager/data/repositories/in_memory_task_repository.dart';
import 'package:project_manager/data/services/project_service.dart';
import 'package:project_manager/data/services/task_service.dart';

// Global instances - shared across the app
// In a real app, you'd use dependency injection (Provider, GetIt, etc.)
final projectRepository = InMemoryProjectRepository();
final taskRepository = InMemoryTaskRepository();

final projectService = ProjectService(projectRepository);
final taskService = TaskService(taskRepository);

void main() {
  runApp(MyApp());
}
```

---

## Step 5: Use in Your UI

**Example: Create a project from a form**

```dart
import 'package:project_manager/data/services/project_service.dart';
import 'package:project_manager/models/project.dart';

class CreateProjectScreen extends StatefulWidget {
  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDeadline;
  
  void _createProject() {
    // Get values from form
    final name = _nameController.text;
    final description = _descriptionController.text.isEmpty 
        ? null 
        : _descriptionController.text;
    
    // Validate
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name is required')),
      );
      return;
    }
    
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deadline is required')),
      );
      return;
    }
    
    // Use service to create project
    final project = projectService.createProject(
      name: name,
      description: description,
      deadline: _selectedDeadline!,
      status: ProjectStatus.notStarted,
    );
    
    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project created!')),
    );
    
    // Go back
    Navigator.pop(context, project); // Return created project
  }
  
  @override
  Widget build(BuildContext context) {
    // Your form UI here...
  }
}
```

**Example: Display projects in a list**

```dart
class ProjectListScreen extends StatefulWidget {
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<Project> _projects = [];
  
  @override
  void initState() {
    super.initState();
    _loadProjects();
  }
  
  void _loadProjects() {
    setState(() {
      _projects = projectService.getAllProjects();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Projects')),
      body: ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return ListTile(
            title: Text(project.name),
            subtitle: Text(project.deadline.toString()),
            onTap: () {
              // Navigate to detail screen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to create screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateProjectScreen()),
          );
          
          // If project was created, refresh list
          if (result != null) {
            _loadProjects();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## Summary: What You Built

1. **Repository Interfaces** - Define what operations exist
2. **In-Memory Implementations** - Store data in Lists
3. **Service Layer** - Business logic wrapper
4. **Global Instances** - Share across app (simple approach)
5. **UI Integration** - Use services in your screens

---

## Next Steps

1. ✅ Create the repository interface files
2. ✅ Create the in-memory implementations
3. ✅ Create the service layer
4. ✅ Wire it up in main.dart
5. ✅ Use in your UI screens

**When you're ready for a database:** Just create new implementations like `HiveProjectRepository` that implement the same interface. Your UI code doesn't change!
