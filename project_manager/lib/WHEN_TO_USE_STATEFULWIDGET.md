# When to Use StatefulWidget vs StatelessWidget

## Quick Decision Guide:

### ✅ **Use StatelessWidget when:**
- Just reading data (`list.length`, `list[index]`)
- Simple property access
- No expensive calculations
- Data is static

### ✅ **Use StatefulWidget when:**
- Filtering/sorting data
- Expensive calculations
- Data processing/transformation
- Need to cache results
- Data might change

---

## Examples:

### **StatelessWidget is Fine:**
```dart
// ✅ Just reading properties - very cheap
class Projects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sampleProjects.length,  // Just reading length
      itemBuilder: (context, index) => 
        ProjectCard(project: sampleProjects[index]),  // Just array access
    );
  }
}
```

### **StatefulWidget Needed:**
```dart
// ❌ Expensive operations - needs caching
class Deadlines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deadlines = sampleDeadlines
        .where(...)      // Filtering
        .toList()        // New list
      ..sort(...);       // Sorting
    // ❌ Runs every rebuild!
  }
}

// ✅ Better: Cache in StatefulWidget
class Deadlines extends StatefulWidget {
  @override
  State<Deadlines> createState() => _DeadlinesState();
}

class _DeadlinesState extends State<Deadlines> {
  late final List<Project> deadlines;
  
  @override
  void initState() {
    super.initState();
    deadlines = sampleDeadlines
        .where(...)
        .toList()
      ..sort(...);
    // ✅ Calculated once!
  }
}
```

---

## Cost Comparison:

| Operation | Cost | Widget Type |
|-----------|------|-------------|
| `list.length` | Very cheap | StatelessWidget ✅ |
| `list[index]` | Very cheap | StatelessWidget ✅ |
| `.where()` | Moderate | StatefulWidget ✅ |
| `.sort()` | Moderate | StatefulWidget ✅ |
| `.map()` | Moderate | StatefulWidget ✅ |
| Complex calculations | Expensive | StatefulWidget ✅ |

---

## Rule of Thumb:

**If the operation takes > 1ms or creates new objects, use StatefulWidget.**

**If it's just reading properties, StatelessWidget is fine.**
