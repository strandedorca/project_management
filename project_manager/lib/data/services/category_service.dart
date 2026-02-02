import 'package:project_manager/data/repositories/category_repository.dart';
import 'package:project_manager/models/category.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  List<Category> getAllCategories() {
    return _repository.getAll();
  }

  Category? getCategoryById(String id) {
    return _repository.getById(id);
  }

  Category createCategory({required String name}) {
    final category = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
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
