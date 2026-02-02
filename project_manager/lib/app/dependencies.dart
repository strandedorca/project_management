import 'package:project_manager/data/repositories/in_memory_category_repository.dart';
import 'package:project_manager/data/repositories/in_memory_project_repository.dart';
import 'package:project_manager/data/repositories/in_memory_tag_repository.dart';
import 'package:project_manager/data/repositories/in_memory_task_repository.dart';
import 'package:project_manager/data/services/category_service.dart';
import 'package:project_manager/data/services/project_service.dart';
import 'package:project_manager/data/services/tag_service.dart';
import 'package:project_manager/data/services/task_service.dart';

/// Global instances - shared across the app.
/// Any file that imports this file can use [projectService], [categoryService], etc.
/// Example: in a page, add `import 'package:project_manager/app/dependencies.dart';`
/// then call `projectService.createProject(...)` or `categoryService.getAllCategories()`.
final projectRepository = InMemoryProjectRepository();
final taskRepository = InMemoryTaskRepository();
final categoryRepository = InMemoryCategoryRepository();
final tagRepository = InMemoryTagRepository();

final projectService = ProjectService(projectRepository);
final taskService = TaskService(taskRepository);
final categoryService = CategoryService(categoryRepository);
final tagService = TagService(tagRepository);
