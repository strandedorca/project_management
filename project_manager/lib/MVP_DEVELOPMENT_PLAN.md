# MVP Development Plan - What to Build Next

## Current Status ✅

- [x] Data models designed and implemented
- [x] Dashboard UI structure exists
- [ ] State management (how to store projects/tasks)
- [ ] Project CRUD operations
- [ ] Task CRUD operations
- [ ] Navigation between screens
- [ ] Forms for creating/editing

## Next Steps (In Order)

### Step 1: State Management (CRITICAL - Do This First!)

**What:** Decide how to store and manage your projects and tasks in memory.

**Why this first?** Everything else depends on this. You need a place to:
- Store projects and tasks
- Add new projects/tasks
- Update existing ones
- Delete them
- Access them from any screen

**Options for MVP:**

#### Option A: Simple StatefulWidget (Recommended for Learning)
**What:** Use `setState()` in a StatefulWidget that holds your data.

**Pros:**
- Simple - no extra packages needed
- Easy to understand
- Perfect for learning
- Good for MVP

**Cons:**
- Can get messy with many screens
- Hard to share data between screens
- Not scalable for large apps

**When to use:** MVP, small apps, learning

**Example Structure:**
```dart
class ProjectProvider extends StatefulWidget {
  // Holds list of projects
  final List<Project> projects = [];
  
  // Methods to add/update/delete
  void addProject(Project project) { ... }
  void updateProject(Project project) { ... }
  void deleteProject(String id) { ... }
}
```

#### Option B: Provider Package (Better, but more complex)
**What:** Use `provider` package for state management.

**Pros:**
- Clean separation of data and UI
- Easy to share data across screens
- Industry standard
- Scales well

**Cons:**
- Requires learning Provider pattern
- More setup
- Might be overkill for MVP

**When to use:** When you have multiple screens that need same data

**Recommendation for MVP:** Start with Option A (StatefulWidget). Learn Provider later.

---

### Step 2: Project CRUD (Create, Read, Update, Delete)

**What:** Build screens and logic to manage projects.

**Order:**
1. **Create Project Form**
   - Text field for name
   - Text field for description (optional)
   - Date picker for deadline
   - Dropdown for status (default: notStarted)
   - "Create" button

2. **Project List Screen**
   - Display all projects
   - Show: name, deadline, status
   - Tap to view details
   - Swipe to delete (optional)

3. **Project Detail Screen**
   - Show all project info
   - Edit button → goes to edit form
   - Delete button
   - List of tasks for this project
   - "Add Task" button

4. **Edit Project Form**
   - Same as create, but pre-filled
   - "Update" button instead of "Create"

**Why this order?**
- Create → Need to create before you can read
- Read → Need to see what you created
- Update → Need to fix mistakes
- Delete → Need to remove old projects

**Flutter Concepts You'll Learn:**
- `TextFormField` - text input
- `DatePicker` - date selection
- `DropdownButton` - selection
- Form validation
- Navigation (`Navigator.push`)

---

### Step 3: Task CRUD

**What:** Build screens and logic to manage tasks.

**Order:**
1. **Create Task Form**
   - Text field for name
   - Text field for description (optional)
   - Date picker for due date (optional)
   - Dropdown for status (default: pending)
   - "Create" button

2. **Task List (in Project Detail)**
   - Show all tasks for a project
   - Show: name, status, due date
   - Tap to view details
   - Checkbox to mark complete

3. **Task Detail Screen** (optional for MVP)
   - Show all task info
   - Edit button
   - Delete button

4. **Edit Task Form** (optional for MVP)
   - Same as create, but pre-filled

**Why simpler than Project?**
- Tasks are simpler (fewer fields)
- Can start with just create + list
- Detail/edit screens can come later

**Flutter Concepts You'll Learn:**
- `Checkbox` - mark complete
- Filtering lists (`where`)
- Conditional rendering

---

### Step 4: Dashboard Integration

**What:** Connect dashboard to real data.

**Tasks:**
1. **Ongoing Projects**
   - Filter: `status == ProjectStatus.ongoing`
   - Count: `projects.where(...).length`
   - Display: List of project cards

2. **Upcoming Deadlines**
   - Filter: `deadline is within next 7 days`
   - Sort: By deadline (soonest first)
   - Display: List of deadline cards

3. **Due Tasks**
   - Filter: `dueDate is within next 7 days AND status != completed`
   - Sort: By due date
   - Display: List of task cards

**Flutter Concepts You'll Learn:**
- List filtering (`where`)
- List sorting (`sort`)
- Date calculations (`difference`)
- Conditional UI (show/hide based on data)

---

### Step 5: Navigation

**What:** Connect all screens together.

**Navigation Flow:**
```
Dashboard
  ├─→ Project List (if you have separate screen)
  │    └─→ Project Detail
  │         ├─→ Edit Project
  │         └─→ Create Task
  │              └─→ Task Detail (optional)
  └─→ Create Project
```

**Flutter Concepts You'll Learn:**
- `Navigator.push()` - go to new screen
- `Navigator.pop()` - go back
- Passing data between screens
- Routes

---

## What NOT to Build Yet

### ❌ Data Persistence
**Why:** Start with in-memory storage (List). Add database later.

**When to add:** After MVP works, add SQLite or Hive.

### ❌ Advanced Features
- Search/filter
- Sorting options
- Project templates
- Batch operations

**Why:** Not essential for MVP. Add after core features work.

### ❌ Time Tracking
- Estimated time
- Actual time spent
- Pomodoro integration

**Why:** Complex feature. Validate core concept first.

---

## Learning Path

### Week 1: Foundation
- [x] Understand data models
- [ ] Set up state management (simple approach)
- [x] Create sample data

### Week 2: Projects
- [ ] Create project form
- [ ] Project list screen
- [ ] Project detail screen
- [ ] Edit/delete projects

### Week 3: Tasks
- [ ] Create task form
- [ ] Task list in project detail
- [ ] Mark tasks complete
- [ ] Delete tasks

### Week 4: Dashboard & Polish
- [ ] Connect dashboard to real data
- [ ] Add navigation
- [ ] Test full flow
- [ ] Fix bugs

---

## Key Flutter Concepts You'll Learn

### 1. **State Management**
- `StatefulWidget` vs `StatelessWidget`
- `setState()` - update UI when data changes
- Lifting state up

### 2. **Forms**
- `Form` widget
- `TextFormField` - text input
- `FormField` - custom inputs
- Validation

### 3. **Lists**
- `ListView` - scrollable list
- `ListView.builder` - efficient list
- Filtering and sorting

### 4. **Navigation**
- `Navigator` - screen navigation
- Passing data between screens
- Routes

### 5. **Date/Time**
- `DateTime` - date handling
- `DatePicker` - date selection
- Date calculations

---

## Questions to Ask Yourself

1. **Where should I store projects/tasks?**
   - Answer: In a StatefulWidget at the top level (or use Provider)

2. **How do I share data between screens?**
   - Answer: Pass it as constructor parameters, or use state management

3. **How do I update the UI when data changes?**
   - Answer: Call `setState()` after modifying data

4. **How do I navigate between screens?**
   - Answer: Use `Navigator.push()` to go forward, `Navigator.pop()` to go back

5. **How do I filter/sort lists?**
   - Answer: Use `where()` and `sort()` methods on List

---

## Recommended Learning Resources

1. **Flutter Documentation**
   - [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
   - [Forms](https://docs.flutter.dev/cookbook/forms)
   - [Navigation](https://docs.flutter.dev/cookbook/navigation)

2. **Practice Exercises**
   - Build a simple todo app first (projects → tasks is similar)
   - Practice form validation
   - Practice list filtering

3. **When Stuck**
   - Read Flutter docs
   - Check Stack Overflow
   - Ask specific questions (not "how do I build this app?")

---

## Next Immediate Action

**Start with:** Simple state management using StatefulWidget

**Create:** A simple `ProjectService` or `ProjectProvider` class that:
- Holds a `List<Project>`
- Has methods: `addProject()`, `getProjects()`, `updateProject()`, `deleteProject()`
- Uses `setState()` to update UI

**Then:** Build the Create Project form and connect it to this service.

**Why this order?** You need somewhere to store projects before you can create them!
