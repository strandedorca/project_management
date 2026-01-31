import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

/// A field for selecting multiple tags with a bottom sheet picker
class TagsInputField extends StatefulWidget {
  const TagsInputField({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
    this.validator,
  });

  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;
  final String? Function(List<String>)? validator;

  // Sample tags - in a real app, this would come from a service/repository
  static const List<String> availableTags = [
    'COMP1000',
    'HIST2088',
    'PHIL1037',
    'Group Project',
    'Essay',
    'Personal',
    'Hurdle',
    'Assignment',
    'Exam',
    'Presentation',
  ];

  @override
  State<TagsInputField> createState() => _TagsInputFieldState();
}

class _TagsInputFieldState extends State<TagsInputField> {
  final TextEditingController _controller = TextEditingController();

  void _showTagsPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.borderRadiusMedium),
        ),
      ),
      builder: (context) => _TagsPickerSheet(
        availableTags: TagsInputField.availableTags,
        selectedTags: widget.selectedTags,
        onTagsChanged: (tags) {
          widget.onTagsChanged(tags);
          _updateControllerText(tags);
        },
      ),
    );
  }

  void _updateControllerText(List<String> tags) {
    _controller.text = tags.isEmpty ? '' : tags.join(', ');
  }

  @override
  void initState() {
    super.initState();
    _updateControllerText(widget.selectedTags);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true, // Prevent manual typing
      cursorColor: Theme.of(context).colorScheme.outline,
      validator: widget.validator != null
          ? (_) => widget.validator!(widget.selectedTags)
          : null,
      onTap: () => _showTagsPicker(context),
      decoration:
          AppDecorations.roundedBorderedInputBorder(
            context,
            AppDimens.borderRadiusSmall,
          ).copyWith(
            suffixIcon: IconButton(
              icon: Icon(Icons.label_outline),
              onPressed: () => _showTagsPicker(context),
            ),
          ),
    );
  }
}

class _TagsPickerSheet extends StatefulWidget {
  const _TagsPickerSheet({
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  final List<String> availableTags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  State<_TagsPickerSheet> createState() => _TagsPickerSheetState();
}

class _TagsPickerSheetState extends State<_TagsPickerSheet> {
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
    widget.onTagsChanged(_selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.appPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Tags',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Done'),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          // Selected tags display
          if (_selectedTags.isNotEmpty) ...[
            Wrap(
              spacing: AppDimens.spacingSmall,
              runSpacing: AppDimens.spacingSmall,
              children: _selectedTags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      onDeleted: () => _toggleTag(tag),
                      deleteIcon: Icon(Icons.close, size: 18),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppDimens.spacingMedium),
          ],
          // Available tags
          Wrap(
            spacing: AppDimens.spacingSmall,
            runSpacing: AppDimens.spacingSmall,
            children: widget.availableTags
                .map(
                  (tag) => FilterChip(
                    label: Text(tag),
                    selected: _selectedTags.contains(tag),
                    onSelected: (_) => _toggleTag(tag),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
