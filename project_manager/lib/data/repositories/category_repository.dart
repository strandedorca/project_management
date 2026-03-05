import 'package:project_manager/data/models/category.dart';

abstract class CategoryRepository {
  List<Category> getAll();

  Category? getById(String id);
  Category create(Category category);
  Category update(Category category);
  bool delete(String id);
}
