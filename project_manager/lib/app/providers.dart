import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/data/repositories/in_memory_category_repository.dart';
import 'package:project_manager/data/repositories/in_memory_project_repository.dart';
import 'package:project_manager/data/repositories/in_memory_tag_repository.dart';
import 'package:project_manager/data/repositories/in_memory_task_repository.dart';
import 'package:project_manager/data/services/category_service.dart';
import 'package:project_manager/data/services/project_service.dart';
import 'package:project_manager/data/services/tag_service.dart';
import 'package:project_manager/data/services/task_service.dart';

// Repositories — created once, shared across the app
final _projectRepositoryProvider = Provider(
  (_) => InMemoryProjectRepository(),
);
final _taskRepositoryProvider = Provider(
  (_) => InMemoryTaskRepository(),
);
final _categoryRepositoryProvider = Provider(
  (_) => InMemoryCategoryRepository(),
);
final _tagRepositoryProvider = Provider(
  (_) => InMemoryTagRepository(),
);

// Services — injected with their repositories
final projectServiceProvider = Provider(
  (ref) => ProjectService(ref.read(_projectRepositoryProvider)),
);
final taskServiceProvider = Provider(
  (ref) => TaskService(ref.read(_taskRepositoryProvider)),
);
final categoryServiceProvider = Provider(
  (ref) => CategoryService(ref.read(_categoryRepositoryProvider)),
);
final tagServiceProvider = Provider(
  (ref) => TagService(ref.read(_tagRepositoryProvider)),
);
