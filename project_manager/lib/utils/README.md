# Utilities Folder - Best Practices

## ✅ **The Right Way: Centralized Utilities**

**Don't:** Import `intl` (or any utility package) in every file  
**Do:** Create utility functions in a central location

---

## Why This Approach?

### 1. **Single Source of Truth**
- All date formatting logic in one place
- Easy to change format across entire app
- Consistent formatting everywhere

### 2. **Cleaner Code**
```dart
// ❌ Bad - Import intl everywhere
import 'package:intl/intl.dart';
Text(DateFormat('MMM d, yyyy').format(date))

// ✅ Good - Import utility once
import 'package:project_manager/utils/date_formatter.dart';
Text(DateFormatter.shortDate(date))
```

### 3. **Easier Maintenance**
- Change date format? Update one file
- Need new format? Add one function
- Test formatting? Test one utility class

### 4. **Better Organization**
- Clear separation of concerns
- Easy to find utility functions
- Scalable as app grows

---

## How Real Projects Do It

### **Common Pattern:**
```
lib/
├── utils/
│   ├── date_formatter.dart    # Date formatting
│   ├── number_formatter.dart  # Number formatting
│   ├── validators.dart         # Input validation
│   └── extensions.dart         # Extension methods
```

### **Usage:**
```dart
// In any file that needs date formatting
import 'package:project_manager/utils/date_formatter.dart';

Text(DateFormatter.shortDate(project.deadline))
Text(DateFormatter.relativeDate(task.dueDate))
```

---

## Available Date Formats

### **Short Date:** `DateFormatter.shortDate(date)`
- Format: "Jan 24, 2026"
- Use: Cards, lists, compact views

### **Medium Date:** `DateFormatter.mediumDate(date)`
- Format: "January 24, 2026"
- Use: Details pages, forms

### **Long Date:** `DateFormatter.longDate(date)`
- Format: "Friday, January 24, 2026"
- Use: Full date display

### **Relative Date:** `DateFormatter.relativeDate(date)`
- Format: "Today", "Tomorrow", "In 3 days"
- Use: Dashboard, quick views

### **Days Until:** `DateFormatter.daysUntil(date)`
- Format: "Due in 3 days", "Overdue by 2 days"
- Use: Deadlines, tasks

### **Custom:** `DateFormatter.custom(date, 'dd/MM/yyyy')`
- Format: Any pattern you need
- Use: Special cases

---

## Adding New Formats

If you need a new format, add it to `date_formatter.dart`:

```dart
/// New format: "24/01/26"
static String compactDate(DateTime date) {
  return DateFormat('dd/MM/yy').format(date);
}
```

Then use it everywhere:
```dart
Text(DateFormatter.compactDate(project.deadline))
```

---

## Summary

✅ **DO:**
- Create utility files in `lib/utils/`
- Import utilities where needed
- Keep formatting logic centralized

❌ **DON'T:**
- Import `intl` directly in every file
- Duplicate formatting code
- Hardcode date formats everywhere

This is the standard approach used in production Flutter apps! 🎯
