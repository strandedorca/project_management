import 'package:flutter/material.dart';
import 'package:project_manager/components/customScrollBar.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/formIconButton.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/data/models/option.dart';
import 'package:project_manager/themes/dimens.dart';

class MultiModalPickerFormField extends StatefulWidget {
  const MultiModalPickerFormField({
    super.key,
    this.modalTitle,
    this.hintText,
    this.initialValues = const [],
    required this.options,
    required this.onSelected,
    this.validator,
    this.suffixIcon,
  });

  final String? modalTitle;
  final String? hintText;
  final List<Option> options;
  final List<String> initialValues;
  final ValueChanged<List<String>> onSelected;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;

  @override
  State<MultiModalPickerFormField> createState() =>
      _MultiModalPickerFormFieldState();
}

class _MultiModalPickerFormFieldState extends State<MultiModalPickerFormField> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late List<String> _selectedValues;
  late final Map<String, String> _valueToLabel = {
    for (var o in widget.options) o.value: o.label,
  };

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialValues);

    if (_selectedValues.isNotEmpty) {
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    _controller.text = _selectedValues
        .map((v) => '#${_valueToLabel[v] ?? ''}')
        .join(', ');
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: 0));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context) {
    ModelBottomSheet.show(
      context,
      title: widget.modalTitle,
      _PickerSheetContent(
        options: widget.options,
        initialValues: _selectedValues,
        onChange: (value) {
          setState(() {
            _selectedValues = value;
            _updateControllerText();
          });
          widget.onSelected(value);
        },
        controller: _controller,
        scrollController: _scrollController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: widget.hintText,
      controller: _controller,
      readOnly: true,
      validator: widget.validator,
      onTap: () => _showPicker(context),
      suffixIcon: widget.suffixIcon != null
          ? FormIconButton(
              iconData: widget.suffixIcon!,
              onPressed: () => _showPicker(context),
            )
          : null,
      maxLines: 1,
    );
  }
}

class _PickerSheetContent extends StatefulWidget {
  const _PickerSheetContent({
    required this.options,
    required this.initialValues,
    required this.onChange,
    required this.controller,
    required this.scrollController,
  });

  final List<Option> options;
  final List<String> initialValues;
  final ValueChanged<List<String>> onChange;
  final TextEditingController controller;
  final ScrollController scrollController;

  @override
  State<_PickerSheetContent> createState() => __PickerSheetContentState();
}

class __PickerSheetContentState extends State<_PickerSheetContent> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialValues);
  }

  void _toggleSelection(String value) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        _selectedValues.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollBar(
      controller: widget.scrollController,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          final option = widget.options[index];
          final isSelected = _selectedValues.contains(option.value);

          return Container(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                : null,
            child: ListTile(
              leading: Icon(
                (option.icon ?? Icons.folder_outlined) as IconData?,
                color: Theme.of(context).colorScheme.outline,
              ),
              title: Text(
                option.label,
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
                _toggleSelection(option.value);
                widget.onChange(_selectedValues);
              },
            ),
          );
        },
      ),
    );
  }
}
