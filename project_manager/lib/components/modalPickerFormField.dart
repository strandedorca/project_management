import 'package:flutter/material.dart';
import 'package:project_manager/components/customScrollBar.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/formIconButton.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/data/models/option.dart';
import 'package:project_manager/themes/dimens.dart';

/// ModalPickerFormField is a form field that when clicked displays a modal bottom sheet for selecting an option from a list of options.
///
/// It uses [ModalBottomSheet] to display the modal bottom sheet and [CustomTextFormField] to display the text field.
/// The controller is managed internally and is used to control the displayed text field.
/// The value is stored in the [selectedValue] and exposed through the [onSelected] callback.
///
/// ## Parameters
/// - (required) [options]: The list of options to display in the modal bottom sheet.
/// - (required) [onSelected]: The callback function to call when an option is selected.
/// - (optional) [initialValue]: The initial value to display in the text field.
/// - (optional) [hintText]: The hint text of the form field when no option is selected.
/// - (optional) [modalTitle]: The title of the modal bottom sheet.
/// - (optional) [validator]: The validator function to validate the input.
/// - (optional) [suffixIcon]: The icon to display in the suffix of the text field.

class ModalPickerFormField extends StatefulWidget {
  const ModalPickerFormField({
    super.key,
    required this.options,
    required this.onSelected,
    this.initialValue,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.modalTitle,
  });

  final String? modalTitle;
  final String? hintText;
  final List<Option> options;
  final String? initialValue;
  final ValueChanged<String> onSelected;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;

  @override
  State<ModalPickerFormField> createState() => _ModalPickerFormFieldState();
}

class _ModalPickerFormFieldState extends State<ModalPickerFormField> {
  late final Map<String, String> _valueToLabel = {
    for (var o in widget.options) o.value: o.label,
  };
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    if (_selectedValue != null) {
      _controller.text = _valueToLabel[_selectedValue!] ?? '';
      if (_controller.text.isEmpty) _selectedValue = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context) {
    if (widget.options.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No options available')));
      return;
    }
    ModelBottomSheet.show(
      context,
      widget.modalTitle,
      _PickerSheetContent(
        options: widget.options,
        selectedValue: _selectedValue,
        onSelected: (value) {
          _controller.text = _valueToLabel[value] ?? '';
          widget.onSelected(value);
          setState(() => _selectedValue = value);
        },
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
    required this.selectedValue,
    required this.onSelected,
    required this.scrollController,
  });

  final List<Option> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;
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
          final isSelected = option.value == selectedValue;

          return Container(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                : null,
            child: ListTile(
              leading: Icon(
                option.icon ?? Icons.folder_outlined,
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
                onSelected(option.value);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
