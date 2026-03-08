# Technical Debt & Known Issues

A running list of problems, shortcuts, and things to revisit.
Items are grouped by area. Address before considering the app production-ready.

---

## Navigation

### `ProjectList` back button crashes when used as a tab
**File:** `lib/pages/projects/projectList.dart`
**Problem:** `Navigator.of(context).pop()` is called unconditionally in the app bar's back button. When `ProjectList` is rendered as a tab inside `IndexedStack`, there is nothing to pop to — the navigation stack is empty and it throws an error.
**Fix applied:** Added `Navigator.of(context).canPop()` check — back button only shows and fires when there is a previous route.
**Deeper issue:** `ProjectList` has an app bar with a back button but is also used as a root tab. Long term, tab pages should not have their own app bar — `AppShell` should control it. See "Nested Scaffold" issue below.

---

### Nested Scaffold in tab pages
**Files:** `lib/pages/projects/projectList.dart`, and any other tab page with its own `Scaffold`
**Problem:** Flutter recommends one `Scaffold` per route. Tab pages inside `IndexedStack` that have their own `Scaffold` cause:
- Duplicate FABs, app bars, or bottom bars visible simultaneously
- Wrong `MediaQuery` safe area padding (double-applied)
- `SnackBar` and `BottomSheet` attaching to the wrong `Scaffold`
- Back button / `PopScope` conflicts
**Fix:** Remove `Scaffold` from tab pages. Tab pages should return plain content widgets (`Column`, `Padding`, etc.). `AppShell`'s `Scaffold` wraps everything.
**Blocked by:** App bar and FAB per-tab logic needs to be moved to `AppShell` first (see App Bar section below).

---

### No nested Navigator per tab
**Problem:** Navigating from a tab page to a detail page (`ProjectList` → `ProjectDetail`) uses the root `Navigator`, which covers `AppShell` entirely. The bottom nav bar disappears on detail pages.
**Fix:** Give each tab its own `Navigator` (nested Navigator pattern). Each tab manages its own navigation stack while `AppShell` stays visible.
**Trade-off:** Adds complexity — each tab needs a `Navigator` wrapper, and back button handling needs care.

---

## App Bar

### App bar not restored when switching tabs
**Files:** `lib/appShell.dart`
**Problem:** When the user switches tabs, `_currentAppBar` is not reset to the new tab's default. It keeps showing whatever app bar was last set (e.g., switching from Dashboard to Projects still shows the Dashboard app bar until the Projects tab registers its own).
**Fix:** In `onSwitchTab`, call `_defaultAppBarForTab(i)` to restore the correct app bar for the new tab index.

### App bar logic split across AppShell and pages
**Problem:** Dashboard uses a callback (`onAppBarChanged`) to update `AppShell`'s app bar. Other tabs use a static `defaultAppBar()` method. This inconsistency makes it hard to reason about who controls the app bar.
**Fix:** Pick one pattern and apply it consistently. Either all tabs use callbacks (requires `RouteAware` for tab-switching), or all tabs define a static default and `AppShell` switches based on tab index.

### App bar not updated when navigating back to a tab
**Problem:** After navigating to `ProjectDetail` and pressing back, the tab's app bar is not re-registered. `AppShell` still shows whatever the detail page last set (or nothing).
**Fix:** Use `RouteAware` + `didPopNext()` in each tab page to re-register its app bar when it becomes visible again.

---

## FAB (Floating Action Button)

### Global FAB doesn't refresh `ProjectList` after creation
**Files:** `lib/appShell.dart`
**Problem:** `AppShell`'s "New Project" FAB calls `ProjectCreationModal.showModal(context)` but has no reference to `ProjectList`'s state. After a project is created, `ProjectList` won't auto-refresh unless it's watching a Riverpod provider.
**Status:** Partially resolved — `ProjectList` now uses `ref.watch(projectsProvider)` and auto-rebuilds when the notifier's state changes.

### FAB context doesn't change per page
**Problem:** The global FAB always shows "New Task" and "New Project" regardless of which page is active. On `ProjectDetail`, the most useful action would be "New Task in this project", not "New Project".
**Fix:** Use per-tab FAB configuration. Either derive from `_selectedTab` in `AppShell`, or use the callback/`RouteAware` pattern similar to app bar.

---

## Forms & Data

### `ProjectDetailForm` still uses `dependencies.dart`
**File:** `lib/pages/projects/projectDetailForm.dart`
**Problem:** `categoryService` and `tagService` are imported from the old global `dependencies.dart` instead of Riverpod providers.
**Fix:** Convert `ProjectDetailForm` to `ConsumerStatefulWidget`. Replace `categoryService` with `ref.read(categoryServiceProvider)` and `tagService` with `ref.read(tagServiceProvider)`.

### `ProjectCreationModel.categoryId` required but nullable
**File:** `lib/pages/projects/projectCreationModel.dart`
**Problem:** `categoryId` is `String?` but `Project.categoryId` is `required String`. The form defaults it to `'0'` or the first category's id, but a `null` value would crash `toProject()`.
**Fix:** Give `categoryId` a non-nullable default or make the form require selection before submit (validator).

### Missing `didUpdateWidget` in picker form fields
**Files:** `lib/components/modalPickerFormField.dart`, `lib/components/multiModalPickerFormField.dart`
**Problem:** Both widgets copy `initialValues`/`initialValue` into local state in `initState`. If the parent resets the form and passes new `initialValues`, the widget's internal state won't update.
**Fix:** Implement `didUpdateWidget` to sync state when `widget.initialValues` changes.

---

## State Management

### `dependencies.dart` not fully removed
**File:** `lib/app/dependencies.dart`
**Problem:** Several pages still import from the old global service file instead of Riverpod providers. This means two systems managing the same services in parallel.
**Files still using it:** `projectDetailForm.dart`, possibly others.
**Fix:** Complete the Riverpod migration. Once all files use providers, delete `dependencies.dart`.

### No task provider / notifier
**Problem:** Tasks don't have a Riverpod notifier yet. Task creation, listing, and updates use the old `dependencies.dart` pattern.
**Fix:** Create `task_providers.dart` following the same pattern as `project_providers.dart`.

---

## UI / UX

### `print` statements left in build methods
**Files:** `lib/pages/projects/projectDetailForm.dart` (line 78: `print(_data.deadline)`)
**Fix:** Remove all `print` calls before any kind of release.

### `maxLines: 1` with many selected tags clips text
**File:** `lib/components/multiModalPickerFormField.dart`
**Status:** Partially fixed — text is manually truncated at 40 characters with `...`.
**Better fix:** Show "X tags selected" when more than N tags are selected, or use a chip-based layout below the field.

### No loading/empty states
**Problem:** Lists show nothing while data is loading, and show nothing when empty. Users have no feedback.
**Fix:** Add empty state widgets ("No projects yet. Create one!") and loading indicators where async fetching occurs.

---

## Code Quality

### Commented-out code throughout
Multiple files have commented-out properties, methods, and TODOs. Clean up before considering the codebase stable.

### `projectDetail.dart` app bar title uses original project name
**Status:** This is intentional — the app bar shows the name the user navigated from, not the live-editing name. Acceptable behavior.

### `_BottomAppBarButton` text says "Create Project" on the detail page
**File:** `lib/pages/projects/projectDetail.dart`
**Fix:** Change button text to "Update Project" (or "Save Changes").

### `ProjectDetailOptionsModal.showModal` does not accept an `onDeleted` callback
**File:** `lib/pages/projects/projectDetailOptionsModal.dart`
**Context:** `ProjectDetail` passes `() => context.go(AppRoutes.projects)` as the third argument to `showModal`, but the current signature only accepts `(BuildContext, Project)`. The callback is silently ignored.
**Fix:** Update `showModal` signature to `showModal(BuildContext context, Project project, [VoidCallback? onDeleted])`, store it on the widget, and call `onDeleted?.call()` after `Navigator.pop(context)` inside `_handleDelete`.
