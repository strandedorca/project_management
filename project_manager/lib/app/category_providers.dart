import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/providers.dart';
import 'package:project_manager/data/models/category.dart';

final categoriesProvider = NotifierProvider<CategoriesNotifier, List<Category>>(
  CategoriesNotifier.new,
);

class CategoriesNotifier extends Notifier<List<Category>> {
  @override
  List<Category> build() {
    // Initial state
    return ref.read(categoryServiceProvider).getAllCategories();
  }

  void add({required String name, String? icon}) {
    final category = ref
        .read(categoryServiceProvider)
        .createCategory(name: name, icon: icon);
    state = [...state, category];
  }
}
