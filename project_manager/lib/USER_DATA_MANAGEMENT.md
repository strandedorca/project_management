# User Data Management Guide

## ✅ The Answer: Fetch Outside, Pass In

**Key Principle:** Widgets should **receive** data, not **fetch** it.

### ❌ Bad (Fetching Inside Widget)
```dart
class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ DON'T DO THIS - Widget is doing too much
    final user = await fetchUserFromApi(); // Can't use await in build()
    return Text(user.name);
  }
}
```

### ✅ Good (Fetching Outside, Passing In)
```dart
// Parent widget fetches
class Dashboard extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    _loadUser(); // Fetch here
  }
  
  Future<void> _loadUser() async {
    final user = await userService.getCurrentUser();
    setState(() => _user = user);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: _user), // Pass to child
    );
  }
}

// Child widget receives
class CustomAppBar extends StatelessWidget {
  final User? user; // ✅ Receives data as parameter
  
  const CustomAppBar({super.key, this.user});
  
  @override
  Widget build(BuildContext context) {
    return Text(user?.name ?? 'User');
  }
}
```

---

## Why This Approach?

### 1. **Separation of Concerns**
- **Widgets** = Display UI
- **Services** = Fetch/Manage Data
- **Parent Widgets** = Coordinate between services and widgets

### 2. **Testability**
```dart
// Easy to test - just pass mock data
testWidgets('AppBar displays user name', (tester) async {
  final mockUser = User(id: '1', name: 'Test User');
  await tester.pumpWidget(CustomAppBar(user: mockUser));
  expect(find.text('Test User'), findsOneWidget);
});
```

### 3. **Reusability**
```dart
// Same widget, different users
CustomAppBar(user: currentUser)
CustomAppBar(user: otherUser)
```

### 4. **Performance**
- Fetch once in `initState()`, not on every `build()`
- Widget rebuilds only when data changes (via `setState`)

---

## Current Implementation

### File Structure
```
lib/
├── models/
│   └── user.dart              # User data model
├── services/
│   └── user_service.dart      # Fetches/manages user data
└── pages/
    └── dashboard/
        ├── dashboard.dart      # Fetches user, passes to AppBar
        └── appbar.dart        # Receives user, displays it
```

### How It Works

1. **Dashboard** (parent) fetches user in `initState()`
2. **Dashboard** passes `User` to `CustomAppBar` via constructor
3. **CustomAppBar** displays the user data

---

## For MVP (Current Setup)

### What You Have Now
- ✅ `User` model
- ✅ `UserService` with mock data
- ✅ `Dashboard` fetches user
- ✅ `CustomAppBar` receives user

### Current Flow
```
Dashboard.initState()
  → UserService.getCurrentUser()
    → Returns mock User
  → setState(_user = user)
    → CustomAppBar(user: _user)
      → Displays user name/image
```

---

## When You Add API

### Step 1: Update UserService
```dart
class UserService {
  Future<User?> getCurrentUser() async {
    // Replace mock with API call
    try {
      final response = await http.get(
        Uri.parse('https://api.yourapp.com/user/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return User.fromJson(json); // Create User from API response
      }
    } catch (e) {
      // Handle error
      return null;
    }
  }
}
```

### Step 2: Add User.fromJson() to User Model
```dart
class User {
  // ... existing fields ...
  
  /// Create User from API JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      email: json['email'],
    );
  }
}
```

### Step 3: Handle Loading States (Optional)
```dart
class _DashboardState extends State<Dashboard> {
  User? _user;
  bool _isLoading = true;
  String? _error;

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final user = await _userService.getCurrentUser();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: CustomAppBar(user: null), // Show placeholder
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_error != null) {
      return Scaffold(
        appBar: CustomAppBar(user: null),
        body: Center(child: Text('Error: $_error')),
      );
    }
    
    return Scaffold(
      appBar: CustomAppBar(user: _user),
      body: /* ... */,
    );
  }
}
```

---

## Alternative Approaches

### Option A: FutureBuilder (Simpler, but less control)
```dart
class Dashboard extends StatelessWidget {
  final UserService _userService = UserService();
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _userService.getCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Scaffold(
          appBar: CustomAppBar(user: user),
          body: /* ... */,
        );
      },
    );
  }
}
```

**Pros:**
- Simpler code
- Built-in loading/error handling

**Cons:**
- Fetches on every rebuild (unless cached)
- Less control over when to refetch

**When to use:** Simple cases, one-time fetch

---

### Option B: Provider/Riverpod (For Complex Apps)
```dart
// Create provider
final userProvider = FutureProvider<User?>((ref) async {
  return await userService.getCurrentUser();
});

// Use in widget
class Dashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return Scaffold(
      appBar: CustomAppBar(
        user: userAsync.value, // Automatically updates when data changes
      ),
    );
  }
}
```

**When to use:** Multiple screens need user data, complex state management

---

## Best Practices Summary

### ✅ DO
- Fetch data in parent widget's `initState()` or `build()`
- Pass data as constructor parameters
- Use `StatefulWidget` for widgets that fetch data
- Handle loading/error states
- Use services to separate data fetching from UI

### ❌ DON'T
- Fetch data inside `build()` of a `StatelessWidget`
- Hardcode data in widgets
- Mix data fetching with UI rendering
- Fetch the same data multiple times

---

## Quick Reference

| Scenario | Approach |
|----------|----------|
| **Simple, one-time fetch** | `FutureBuilder` in parent |
| **Need to refetch/update** | `StatefulWidget` with `initState()` |
| **Multiple screens need data** | Provider/Riverpod |
| **MVP/Learning** | `StatefulWidget` (current approach) ✅ |

---

## Questions?

### Q: Should I fetch in `build()` or `initState()`?
**A:** `initState()` - called once, perfect for one-time fetches. `build()` runs on every rebuild.

### Q: What if the user data changes?
**A:** Call `_loadUser()` again, then `setState()` to update UI.

### Q: Can I use `StatelessWidget` with `FutureBuilder`?
**A:** Yes, but it fetches on every rebuild. Better for simple cases.

### Q: When should I use Provider/Riverpod?
**A:** When multiple screens need the same data, or when state management gets complex.
