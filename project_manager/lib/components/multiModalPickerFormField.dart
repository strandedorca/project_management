import 'package:flutter/material.dart';
import 'package:project_manager/components/customScrollBar.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/formIconButton.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/models/option.dart';
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
  final ValueChanged<String> onSelected;
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

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialValues;
    if (_selectedValues.isNotEmpty) {
      _controller.text = widget.options
          .where((e) => _selectedValues.contains(e.value))
          .map((e) => e.label)
          .join(', ');
    }
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
      widget.modalTitle,
      _PickerSheetContent(
        options: widget.options,
        selectedValues: _selectedValues,
        onSelected: (value) {
          widget.onSelected(value);
          setState(() => _selectedValues = [..._selectedValues, value]);
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

class _PickerSheetContent extends StatelessWidget {
  const _PickerSheetContent({
    required this.options,
    required this.selectedValues,
    required this.onSelected,
    required this.controller,
    required this.scrollController,
  });

  final List<Option> options;
  final List<String> selectedValues;
  final ValueChanged<String> onSelected;
  final TextEditingController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollBar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selectedValues.contains(option.value);

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
                controller.text += ', $option.label';
                onSelected(option.value);
              },
            ),
          );
        },
      ),
    );
  }
}
