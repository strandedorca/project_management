import 'package:project_manager/data/repositories/tag_repository.dart';
import 'package:project_manager/models/tag.dart';

class InMemoryTagRepository implements TagRepository {
  final List<Tag> _tags = [];

  @override
  List<Tag> getAll() {
    // return List.from(_tags);
    // Sample tags -  TODO
    final List<Tag> tags = [
      Tag(id: '1', name: 'Ambi'),
      Tag(id: '2', name: 'Blender'),
      Tag(id: '3', name: 'Cinema 4D'),
      Tag(id: '4', name: 'Maya'),
      Tag(id: '5', name: 'Substance Painter'),
      Tag(id: '6', name: 'Substance Designer'),
      Tag(id: '7', name: 'Substance Render'),
      Tag(id: '8', name: 'Substance Matte'),
      Tag(id: '9', name: 'Substance Normal'),
      Tag(id: '10', name: 'Substance Displacement'),
      Tag(id: '11', name: 'Substance Height'),
      Tag(id: '12', name: 'Substance Roughness'),
      Tag(id: '13', name: 'Substance Metallic'),
      Tag(id: '14', name: 'Substance Ambient Occlusion'),
    ];
    return tags;
  }

  @override
  Tag create(Tag tag) {
    _tags.add(tag);
    return tag;
  }

  @override
  bool delete(String id) {
    final index = _tags.indexWhere((tag) => tag.id == id);
    if (index == -1) {
      return false;
    }
    _tags.removeAt(index);
    return true;
  }

  @override
  Tag? getById(String id) {
    try {
      return _tags.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Tag update(Tag tag) {
    final index = _tags.indexWhere((t) => t.id == tag.id);
    if (index == -1) {
      throw Exception('Tag not found: ${tag.id}');
    }
    _tags[index] = tag;
    return tag;
  }
}
