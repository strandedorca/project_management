import 'package:project_manager/models/tag.dart';

abstract class TagRepository {
  List<Tag> getAll();
  Tag? getById(String id);
  Tag create(Tag tag);
  Tag update(Tag tag);
  bool delete(String id);
}
