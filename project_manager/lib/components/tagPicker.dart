import 'package:flutter/material.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/models/tag.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class TagsPicker extends StatelessWidget {
  const TagsPicker({
    super.key,
    required this.allTags,
    required this.selectedTagIds,
    required this.onTagsChanged,
    // required this.onTagRemoved,
  });

  final List<Tag> allTags;
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onTagsChanged;
  // final ValueChanged<String> onTagRemoved;

  void _showPicker(BuildContext context) {
    ModelBottomSheet.show(
      context,
      'Select Tags',
      _TagsPickerSheetContent(
        allTags: allTags,
        selectedTagIds: selectedTagIds,
        onTagsChanged: onTagsChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: AppDimens.spacingSmall,
      spacing: AppDimens.spacingSmall,
      children: [
        // Selected tags
        ...selectedTagIds.map((tagId) {
          final tagName = allTags.firstWhere((tag) => tag.id == tagId).name;
          return InkWell(
            onDoubleTap: () {
              onTagsChanged(selectedTagIds.where((id) => id != tagId).toList());
            },
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spacingSmall,
                vertical: AppDimens.spacingSmall,
              ),
              decoration: AppDecorations.roundIconFrame(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tagName),
                  const SizedBox(width: AppDimens.spacingExtraSmall),
                  Icon(Icons.close, size: AppDimens.iconSmall),
                ],
              ),
            ),
          );
        }),
        // Add tag button
        Container(
          decoration: AppDecorations.roundIconFrame(context),
          child: IconButton(
            constraints: BoxConstraints.tight(
              Size(
                AppDimens.iconSmall + AppDimens.spacingSmall * 2,
                AppDimens.iconSmall + AppDimens.spacingSmall * 2,
              ),
            ),
            icon: Icon(Icons.add, size: AppDimens.iconSmall),
            onPressed: () => _showPicker(context),
          ),
        ),
      ],
    );
  }
}

class _TagsPickerSheetContent extends StatefulWidget {
  const _TagsPickerSheetContent({
    required this.allTags,
    required this.selectedTagIds,
    required this.onTagsChanged,
  });

  final List<Tag> allTags;
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  State<_TagsPickerSheetContent> createState() =>
      _TagsPickerSheetContentState();
}

class _TagsPickerSheetContentState extends State<_TagsPickerSheetContent> {
  late List<String> _selectedTagIds;

  @override
  void initState() {
    super.initState();
    _selectedTagIds = List.from(widget.selectedTagIds);
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_selectedTagIds.contains(tagId)) {
        _selectedTagIds.remove(tagId);
      } else {
        _selectedTagIds.add(tagId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.allTags.length,
      itemBuilder: (context, index) {
        final tag = widget.allTags[index];
        final isSelected = _selectedTagIds.contains(tag.id);

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
            onTap: () {
              // Change local state & call the parent callback
              _toggleTag(tag.id);
              widget.onTagsChanged(List.from(_selectedTagIds));
            },
          ),
        );
      },
    );
  }
}
