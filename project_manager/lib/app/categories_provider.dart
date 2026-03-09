import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/providers.dart';
import 'package:project_manager/data/models/category.dart';
import 'package:project_manager/data/models/option.dart';

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

final categoryOptionsProvider = Provider<List<Option>>((ref) {
  return ref
      .watch(categoriesProvider)
      .map((e) => Option.fromValues(e.id, e.name, Icons.folder_outlined))
      .toList();
});
