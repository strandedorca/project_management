import 'package:flutter/material.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/models/tag.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class TagsPickerFormField extends StatelessWidget {
  const TagsPickerFormField({
    super.key,
    required this.availableTags,
    required this.selectedTagIds,
    required this.onTagsChanged,
  });

  final List<Tag> availableTags;
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onTagsChanged;

  void _showPicker(BuildContext context) {
    ModelBottomSheet.show(
      context,
      'Select Tags',
      _TagsPickerSheetContent(
        availableTags: availableTags,
        selectedTagIds: selectedTagIds,
        onTagsChanged: onTagsChanged,
      ),
    );
  }

  String _tagName(String id) {
    for (final t in availableTags) {
      if (t.id == id) return t.name;
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.spacingSmall,
      runSpacing: AppDimens.spacingSmall,
      children: [
        ...selectedTagIds.map(
          (id) => Container(
            decoration: AppDecorations.roundIconFrame(context),
            child: Text(_tagName(id)),
          ),
        ),
        Container(
          decoration: AppDecorations.roundIconFrame(context),
          child: IconButton(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.add),
            onPressed: () => _showPicker(context),
          ),
        ),
      ],
    );
  }
}

class _TagsPickerSheetContent extends StatefulWidget {
  const _TagsPickerSheetContent({
    required this.availableTags,
    required this.selectedTagIds,
    required this.onTagsChanged,
  });

  final List<Tag> availableTags;
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  State<_TagsPickerSheetContent> createState() =>
      _TagsPickerSheetContentState();
}

class _TagsPickerSheetContentState extends State<_TagsPickerSheetContent> {
  late List<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedTagIds);
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_selectedIds.contains(tagId)) {
        _selectedIds.remove(tagId);
      } else {
        _selectedIds.add(tagId);
      }
    });
    widget.onTagsChanged(List.from(_selectedIds));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.availableTags.length,
      itemBuilder: (context, index) {
        final tag = widget.availableTags[index];
        final isSelected = _selectedIds.contains(tag.id);
        return Container(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
              : null,
          child: ListTile(
            leading: Icon(
              Icons.tag_outlined,
              color: Theme.of(context).colorScheme.outline,
            ),
            title: Text(
              tag.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.outline,
                  )
                : null,
            horizontalTitleGap: AppDimens.spacingMedium,
            minLeadingWidth: 0,
            onTap: () => _toggleTag(tag.id),
          ),
        );
      },
    );
  }
}
