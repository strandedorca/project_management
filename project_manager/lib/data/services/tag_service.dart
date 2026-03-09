import 'package:project_manager/data/models/tag.dart';
import 'package:project_manager/data/repositories/tag_repository.dart';

class TagService {
  final TagRepository _repository;

  TagService(this._repository);

  List<Tag> getAllTags() {
    return _repository.getAll();
  }

  Tag createTag({required String name}) {
    final tag = Tag(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    return _repository.create(tag);
  }

  Tag updateTag(Tag tag) {
    return _repository.update(tag);
  }

  bool deleteTag(String id) {
    return _repository.delete(id);
  }

  Tag? getTagById(String id) {
    return _repository.getById(id);
  }

  List<Tag> getTagsByIds(List<String> ids) {
    return _repository.getAll().where((tag) => ids.contains(tag.id)).toList();
  }
}
