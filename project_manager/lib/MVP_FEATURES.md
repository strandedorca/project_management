# MVP Feature Scope

## Core MVP Features (Must Have)

### 1. **Project Management**
- ✅ Create a project (name, deadline, description)
- ✅ View project list
- ✅ View project details
- ✅ Edit project
- ✅ Delete project

**Why this first?** Projects are the foundation. Without projects, nothing else matters. This is the simplest CRUD (Create, Read, Update, Delete) operation.

### 2. **Task/Subtask Management**
- ✅ Create tasks within a project
- ✅ View task list for a project
- ✅ Mark task as complete
- ✅ Delete task

**Why this second?** Tasks are the building blocks. Users need to break down projects. We'll keep it simple - no time tracking, no complex scheduling yet.

### 3. **Dashboard Overview**
- ✅ Show count of ongoing projects
- ✅ Show upcoming deadlines (next 7 days)
- ✅ Show due tasks (next 7 days)

**Why this third?** Gives users a quick overview. Simple counts and lists - no complex calculations yet.

## What We're NOT Building (Yet)

### ❌ Time Tracking
- No estimated time
- No actual time spent
- No pomodoro integration
- **Reason:** Adds complexity. Can be added later as a separate feature.

### ❌ Reminders/Notifications
- No push notifications
- No calendar integration
- **Reason:** Requires platform-specific code and permissions. Not core to MVP.

### ❌ Advanced Features
- No project templates
- No batch operations
- No search/filter
- No project categories/types
- No tags (we'll keep it simple)
- **Reason:** These are "nice to have" but not essential for validating the core concept.

### ❌ User Authentication
- No login/logout
- Single user app
- **Reason:** Simplifies development. Can add multi-user later.

### ❌ Data Persistence
- Start with in-memory storage (List)
- Later: Add local database (SQLite/Hive)
- **Reason:** Get the UI/UX right first, then worry about persistence.

## MVP User Flow (Simplified)

1. User opens app → Sees Dashboard
2. User taps (+) → Creates Project
3. User taps Project → Sees Project Detail
4. User taps "Add Task" → Creates Task
5. User marks task complete → Progress updates
6. User navigates back → Sees updated Dashboard

**Total Screens Needed:**
- Dashboard (already exists)
- Project List (or use Dashboard)
- Project Detail
- Project Create/Edit Form
- Task Create/Edit Form

## Development Order

1. **Data Models** (this document)
2. **State Management** (simple approach first)
3. **Project CRUD** (Create, Read, Update, Delete)
4. **Task CRUD**
5. **Dashboard Integration**
6. **Navigation**

## Why This Approach?

**MVP Philosophy:** Build the smallest thing that provides value. Once users can create projects and tasks, you have a working app. Everything else is enhancement.

**Learning Approach:** Start simple, add complexity gradually. You'll learn:
- Flutter basics (Widgets, Navigation)
- State management (even simple setState)
- Data modeling
- App architecture

**Iterative Development:** Build → Test → Learn → Improve. Don't try to build everything at once.
