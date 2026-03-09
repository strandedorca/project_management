import 'package:project_manager/data/models/category.dart';
import 'package:project_manager/data/repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  void initializeSystemCategories() {
    final categories = _repository.getAll();
    if (!categories.any((c) => c.id == 'inbox')) {
      _repository.create(Category(id: 'inbox', name: 'Inbox', isSystem: true));
    }
  }

  List<Category> getAllCategories() {
    return _repository.getAll();
  }

  Category? getCategoryById(String id) {
    return _repository.getById(id);
  }

  Category createCategory({required String name, String? icon}) {
    final category = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: icon,
    );
    return _repository.create(category);
  }

  Category updateCategory(Category category) {
    return _repository.update(category);
  }

  bool deleteCategory(String id) {
    return _repository.delete(id);
  }
}
