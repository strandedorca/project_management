# How to Use Custom Text Styles

## ✅ Quick Start

Your text theme is already set up! Just use it in your widgets.

---

## Method 1: Using Theme.of(context) (Recommended)

**Best for:** Most cases - automatically adapts to theme changes

```dart
Text(
  'Hello World',
  style: Theme.of(context).textTheme.titleLarge,
)
```

**Why this is best:**
- ✅ Automatically uses the correct theme (light/dark)
- ✅ Updates if theme changes
- ✅ Follows Material Design conventions

---

## Method 2: Direct Access (Rare Cases)

**Best for:** When you need the style outside of a widget context

```dart
Text(
  'Hello World',
  style: AppTextStyles.lightTextTheme.titleLarge,
)
```

**When to use:**
- Outside of `build()` method
- In static methods
- When you specifically need light theme (not recommended)

---

## Common Text Styles & When to Use Them

### Headlines (Section Titles)
```dart
// Large section heading
Text('Ongoing Projects', 
  style: Theme.of(context).textTheme.headlineMedium,
)

// Medium section heading
Text('Upcoming Deadlines',
  style: Theme.of(context).textTheme.headlineSmall,
)
```

### Titles (Card Titles, List Items)
```dart
// Card title
Text(project.name,
  style: Theme.of(context).textTheme.titleLarge,
)

// List item title
Text(task.name,
  style: Theme.of(context).textTheme.titleMedium,
)
```

### Body Text (Regular Content)
```dart
// Regular paragraph text
Text(project.description ?? '',
  style: Theme.of(context).textTheme.bodyMedium,
)

// Small text (captions, metadata)
Text('Due in 3 days',
  style: Theme.of(context).textTheme.bodySmall,
)
```

### Labels (Buttons, Chips, Form Labels)
```dart
// Button text
ElevatedButton(
  child: Text('Save', 
    style: Theme.of(context).textTheme.labelLarge,
  ),
)

// Chip label
Chip(
  label: Text('Tag',
    style: Theme.of(context).textTheme.labelMedium,
  ),
)
```

---

## Real Examples from Your App

### Example 1: Section Title (Already Using!)
```dart
// In section.dart
Text(
  title, 
  style: Theme.of(context).textTheme.titleLarge, // ✅ Good!
)
```

### Example 2: AppBar Greeting
```dart
// In appbar.dart
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: _getTimebasedGreeting(),
        style: Theme.of(context).textTheme.bodyLarge, // ✅ Use body style
      ),
      TextSpan(
        text: '$userName!',
        style: Theme.of(context).textTheme.titleLarge, // ✅ Use title for emphasis
      ),
    ],
  ),
)
```

### Example 3: Project Card
```dart
// In projectcard.dart
Text(
  project.name,
  style: Theme.of(context).textTheme.titleMedium, // ✅ Card title
)

Text(
  'Due: ${formatDate(project.deadline)}',
  style: Theme.of(context).textTheme.bodySmall, // ✅ Small metadata
)
```

---

## Customizing Individual Text Styles

### Override Specific Properties
```dart
Text(
  'Custom Text',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    color: AppColors.accent,        // Change color
    fontWeight: FontWeight.bold,   // Change weight
    fontSize: 20,                  // Change size
  ),
)
```

### Combine Multiple Styles
```dart
Text(
  'Bold and Colored',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  ),
)
```

---

## Text Style Properties Explained

### Font Size
- **displayLarge**: 57px - Hero text
- **headlineLarge**: 32px - Major sections
- **titleLarge**: 22px - Card titles
- **bodyMedium**: 14px - Regular text (default)
- **labelSmall**: 11px - Tiny labels

### Font Weight
- **w400** (normal) - Regular text
- **w500** (medium) - Slightly emphasized
- **w600** (semi-bold) - Titles, headings
- **w700** (bold) - Strong emphasis

### Letter Spacing
- Positive values = more space between letters
- Negative values = tighter spacing
- 0 = default spacing

### Height (Line Height)
- 1.0 = tight spacing
- 1.5 = comfortable reading (default for body)
- 2.0 = very loose spacing

---

## Best Practices

### ✅ DO
- Use `Theme.of(context).textTheme` for consistency
- Choose the right style category (headline vs title vs body)
- Use `copyWith()` to make small adjustments
- Keep text styles in `text_styles.dart` centralized

### ❌ DON'T
- Don't hardcode font sizes in widgets
- Don't create new TextStyle objects everywhere
- Don't use `AppTextStyles.lightTextTheme` directly in widgets (use Theme.of)
- Don't mix different text styles randomly

---

## Common Patterns

### Pattern 1: Title + Subtitle
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Project Name',
      style: Theme.of(context).textTheme.titleLarge,
    ),
    Text(
      'Due in 3 days',
      style: Theme.of(context).textTheme.bodySmall,
    ),
  ],
)
```

### Pattern 2: Emphasized Text
```dart
Text.rich(
  TextSpan(
    text: 'Total: ',
    style: Theme.of(context).textTheme.bodyMedium,
    children: [
      TextSpan(
        text: '\$1,234',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    ],
  ),
)
```

### Pattern 3: Button with Custom Style
```dart
TextButton(
  onPressed: () {},
  child: Text(
    'See All',
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      color: AppColors.primary,
    ),
  ),
)
```

---

## Adding Custom Text Styles

If you need styles not in the standard TextTheme:

### Option 1: Add to AppTextStyles (Recommended)
```dart
class AppTextStyles {
  static final TextTheme lightTextTheme = TextTheme(
    // ... existing styles ...
  );

  // Custom styles
  static TextStyle get cardTitle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get metadata => TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

// Usage:
Text('Custom', style: AppTextStyles.cardTitle)
```

### Option 2: Use copyWith() (Quick Fix)
```dart
Text(
  'Custom',
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  ),
)
```

---

## Quick Reference Table

| Style | Size | Weight | Use Case |
|-------|------|--------|----------|
| `headlineLarge` | 32px | w600 | Major section titles |
| `headlineMedium` | 28px | w600 | Section headings |
| `headlineSmall` | 24px | w600 | Subsection headings |
| `titleLarge` | 22px | w600 | Card titles |
| `titleMedium` | 16px | w600 | List item titles |
| `titleSmall` | 14px | w600 | Small titles |
| `bodyLarge` | 16px | w400 | Large body text |
| `bodyMedium` | 14px | w400 | Regular text (default) |
| `bodySmall` | 12px | w400 | Small text, captions |
| `labelLarge` | 14px | w600 | Button text |
| `labelMedium` | 12px | w600 | Chip labels |
| `labelSmall` | 11px | w500 | Tiny labels |

---

## Troubleshooting

### Problem: Text style is null
**Solution:** Use null-aware operator
```dart
Text(
  'Hello',
  style: Theme.of(context).textTheme.titleLarge ?? TextStyle(fontSize: 22),
)
```

### Problem: Want to use Google Fonts
**Solution:** 
1. Install: `flutter pub add google_fonts`
2. Update `text_styles.dart`:
```dart
import 'package:google_fonts/google_fonts.dart';

static final TextTheme lightTextTheme = TextTheme(
  titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
  // ... other styles
);
```

### Problem: Text doesn't match theme
**Solution:** Make sure you're using `Theme.of(context).textTheme`, not `AppTextStyles.lightTextTheme` directly

---

## Summary

1. **Define styles** in `text_styles.dart` ✅ (Already done!)
2. **Use in widgets** with `Theme.of(context).textTheme.styleName` ✅
3. **Customize** with `copyWith()` when needed ✅
4. **Keep consistent** - use the right style category ✅

Your text theme is ready to use! 🎉
