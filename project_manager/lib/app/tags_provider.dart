import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/providers.dart';
import 'package:project_manager/data/models/option.dart';
import 'package:project_manager/data/models/tag.dart';

final tagsProvider = NotifierProvider<TagsNotifier, List<Tag>>(
  TagsNotifier.new,
);

class TagsNotifier extends Notifier<List<Tag>> {
  @override
  List<Tag> build() {
    return ref.read(tagServiceProvider).getAllTags();
  }

  void add({required String name}) {
    final tag = ref.read(tagServiceProvider).createTag(name: name);
    state = [...state, tag];
  }
}

final tagOptionsProvider = Provider<List<Option>>((ref) {
  return ref
      .watch(tagsProvider)
      .map((e) => Option.fromValues(e.id, e.name, Icons.tag_outlined))
      .toList();
});
