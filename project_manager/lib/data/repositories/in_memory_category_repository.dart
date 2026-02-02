import 'package:project_manager/data/repositories/category_repository.dart';
import 'package:project_manager/models/category.dart';

class InMemoryCategoryRepository implements CategoryRepository {
  // Private list of all categories. Only Inbox exists by default.
  final List<Category> _categories = [
    Category(id: '0', name: 'Inbox'), // Default category - always exists
  ];

  @override
  List<Category> getAll() {
    // return List.from(_categories); // Return a copy
    // sample categories:
    final List<Category> sampleCategories = [
      Category(id: '0', name: 'Inbox'),
      Category(id: '1', name: 'Work'),
      Category(id: '2', name: 'Personal'),
      Category(id: '3', name: 'School'),
      Category(id: '4', name: 'Health'),
      Category(id: '5', name: 'Finance'),
      Category(id: '6', name: 'Travel'),
      Category(id: '7', name: 'Other'),
    ];
    return sampleCategories;
  }

  @override
  Category? getById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null; // If not found, return null
    }
  }

  @override
  Category create(Category category) {
    _categories.add(category);
    return category; // Return the category added
  }

  static const String _inboxId = '0';

  @override
  bool delete(String id) {
    if (id == _inboxId) return false; // Inbox cannot be deleted
    final index = _categories.indexWhere((category) => category.id == id);
    if (index == -1) {
      return false; // If not found, return false
    }
    _categories.removeAt(index);
    return true; // Return true if deleted
  }

  @override
  Category update(Category category) {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index == -1) {
      throw Exception('Category not found: ${category.id}');
    }
    _categories[index] = category;
    return category;
  }
}
