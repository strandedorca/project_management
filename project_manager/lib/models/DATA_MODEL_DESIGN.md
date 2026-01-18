# Data Model Design - Detailed Explanation

## Design Principles

### 1. **Immutable Models (Final Fields)**

**What:** All fields are `final` - once created, they can't be changed.
**Why:**

- Prevents bugs (can't accidentally modify data)
- Makes code predictable
- Flutter/Dart best practice
- Forces you to create new instances when updating (which is safer)

**Example:**

```dart
// ✅ Good - Immutable
class Project {
  final String id;
  final String name;
}

// ❌ Bad - Mutable (can cause bugs)
class Project {
  String id;  // Can be changed anywhere!
  String name;
}
```

### 2. **Nullable vs Non-Nullable**

**What:** Some fields are `String?` (nullable) vs `String` (required).
**Why:**

- Required fields: Must always have a value (name, id)
- Optional fields: May or may not exist (description, tags)
- Dart's null safety prevents null pointer errors
- Makes your code self-documenting

**Example:**

```dart
final String name;        // Required - must always exist
final String? description; // Optional - can be null
```

### 3. **Enums for Status**

**What:** Use `enum` instead of `String` for status.
**Why:**

- Type safety (can't accidentally use wrong status)
- IDE autocomplete
- Easy to refactor later
- Prevents typos ("ongoing" vs "Ongoing" vs "ONGOING")

### 4. **ID as String**

**What:** Use `String` for IDs, not `int`.
**Why:**

- More flexible (can use UUIDs later)
- Easier to generate (no need to track next number)
- Common in modern apps
- Can use package:uuid for unique IDs

### 5. **DateTime vs String for Dates**

**What:** Use `DateTime` for dates, not `String`.
**Why:**

- Type safety
- Built-in date operations (difference, comparison)
- Easy formatting when displaying
- Prevents invalid dates

**Common Mistake:**

```dart
// ❌ Bad
final String deadline; // "2024-01-01" - can't do math on this!

// ✅ Good
final DateTime deadline; // Can calculate days until deadline
```

## Model Relationships

### Project → Tasks (One-to-Many)

**What:** One project has many tasks.
**How:** Tasks store `projectId` to link back to project.
**Why:**

- Tasks belong to a project
- Can query "all tasks for project X"
- Can delete project and cascade delete tasks (later)

```
Project (id: "1", name: "Build App")
  └── Task (id: "1", projectId: "1", name: "Design UI")
  └── Task (id: "2", projectId: "1", name: "Code Backend")
```

## Field-by-Field Explanation

### Project Model

```dart
class Project {
  final String id;              // Unique identifier
  final String name;            // Required - project name
  final String? description;    // Optional - detailed info
  final DateTime deadline;      // When project is due
  final ProjectStatus status;   // ongoing, notStarted, completed
  final DateTime createdAt;     // When project was created
  final DateTime updatedAt;     // Last modification time
}
```

**Field Explanations:**

1. **id** (String)

   - Unique identifier for each project
   - Generated when project is created
   - Used to link tasks to projects
   - Used for navigation (pass project ID to detail page)

2. **name** (String, required)

   - User-facing project name
   - Required because every project needs a name
   - Displayed in lists and cards

3. **description** (String?, nullable)

   - Optional detailed information
   - Nullable because not all projects need description
   - Can be empty string or null (we'll use null)

4. **deadline** (DateTime)

   - When the project is due
   - Used for sorting and filtering
   - Can calculate "days until deadline"
   - Used in dashboard "Upcoming Deadlines"

5. **status** (ProjectStatus enum)

   - Tracks project state
   - Used for filtering (show only ongoing projects)
   - Affects UI (completed projects might look different)

6. **createdAt** (DateTime)

   - Audit trail - when was this created?
   - Useful for sorting (newest first)
   - Good practice for any data model

7. **updatedAt** (DateTime)
   - Tracks last modification
   - Useful for syncing (if you add backend later)
   - Can show "Last updated 2 days ago"

### Task Model

```dart
class Task {
  final String id;              // Unique identifier
  final String name;            // Task name
  final String? description;    // Optional details
  final String projectId;       // Links to parent project
  final DateTime? dueDate;      // Optional - when task is due
  final TaskStatus status;      // pending, inProgress, completed
  final DateTime createdAt;     // When task was created
  final DateTime updatedAt;     // Last modification time
}
```

**Field Explanations:**

1. **id** (String)

   - Unique identifier
   - Used for updates/deletes
   - Used for navigation

2. **name** (String, required)

   - Task name (e.g., "Design login page")
   - Required - every task needs a name

3. **description** (String?, nullable)

   - Optional detailed information
   - Can include notes, requirements, etc.

4. **projectId** (String, required)

   - **Critical:** Links task to its parent project
   - Used to query "all tasks for project X"
   - Required because every task belongs to a project

5. **dueDate** (DateTime?, nullable)

   - Optional - task might not have specific deadline
   - Used in dashboard "Due Tasks"
   - Can be null if task doesn't have deadline

6. **status** (TaskStatus enum)

   - pending: Not started
   - inProgress: Currently working on it
   - completed: Done!
   - Used for filtering and progress calculation

7. **createdAt/updatedAt** (DateTime)
   - Same as Project - audit trail

## What We're NOT Including (Yet)

### ❌ Estimated Time / Actual Time

**Why:** Adds complexity. For MVP, we just need to know if task is done or not.

### ❌ Time Allocations / Calendar Integration

**Why:** Requires date/time pickers, calendar views. Not essential for MVP.

### ❌ Task Dependencies

**Why:** Complex feature. Can add later if needed.

### ❌ Task Priority

**Why:** Can add later. Status is more important for MVP.

### ❌ Tags/Categories

**Why:** Simplifies model. Can add later as separate feature.

## Flutter-Specific Considerations

### 1. **Equality & HashCode**

**Why needed:** Flutter uses these for:

- List operations (contains, indexOf)
- Set operations
- Widget rebuild optimization

**How to implement:**

```dart
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is Project && other.id == id;
}

@override
int get hashCode => id.hashCode;
```

**Explanation:** Two projects are equal if they have the same ID. This makes sense because ID is unique.

### 2. **JSON Serialization (Future)**

**Why:** When you add persistence (local database or API), you'll need to convert models to/from JSON.

**Example:**

```dart
// Convert Project to JSON (for saving)
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'deadline': deadline.toIso8601String(),
    // ...
  };
}

// Create Project from JSON (for loading)
factory Project.fromJson(Map<String, dynamic> json) {
  return Project(
    id: json['id'],
    name: json['name'],
    deadline: DateTime.parse(json['deadline']),
    // ...
  );
}
```

**For MVP:** Not needed yet, but good to know.

### 3. **CopyWith Pattern**

**Why:** Since models are immutable, to update you create a new instance with changed values.

**Example:**

```dart
Project copyWith({
  String? name,
  String? description,
  DateTime? deadline,
  ProjectStatus? status,
}) {
  return Project(
    id: id,  // Keep same ID
    name: name ?? this.name,  // Use new value or keep old
    description: description ?? this.description,
    deadline: deadline ?? this.deadline,
    status: status ?? this.status,
    createdAt: createdAt,  // Don't change
    updatedAt: DateTime.now(),  // Update timestamp
  );
}
```

**Usage:**

```dart
// Update project name
final updatedProject = project.copyWith(
  name: 'New Name',
  updatedAt: DateTime.now(),
);
```

**For MVP:** You can skip this initially and just create new instances, but it's a common pattern.

## Summary

**Core Models:**

1. `Project` - Main entity
2. `Task` - Belongs to Project
3. `ProjectStatus` - Enum for project state
4. `TaskStatus` - Enum for task state

**Key Decisions:**

- Immutable models (final fields)
- Use DateTime, not String for dates
- Use enums, not strings for status
- Tasks link to projects via projectId
- Keep it simple - no time tracking, no complex features

**Next Steps:**

1. Implement these models
2. Create sample data
3. Build UI to display them
4. Add CRUD operations
