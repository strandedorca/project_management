# Using IntrinsicHeight for Dynamic Card Heights

## The Problem:
- SizedBox(height: 200) forces 200px, even if cards are only 150px
- Results in blank space

## Solution: IntrinsicHeight

```dart
IntrinsicHeight(
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: sampleProjects.length,
    itemBuilder: (context, index) =>
        ProjectCard(project: sampleProjects[index]),
  ),
)
```

**How it works:**
- IntrinsicHeight measures all children first
- Finds the tallest child (e.g., 150px)
- Sets ListView height to that (150px)
- No blank space!

**Pros:**
- ✅ No blank space
- ✅ Cards size to content
- ✅ Dynamic height

**Cons:**
- ⚠️ Slightly more expensive (measures all children)
- ⚠️ All cards must be rendered to find tallest

## Alternative: Use a reasonable fixed height

If all cards are roughly the same size, just pick a good height:

```dart
SizedBox(
  height: 180, // Based on your card design
  child: ListView.builder(...),
)
```
