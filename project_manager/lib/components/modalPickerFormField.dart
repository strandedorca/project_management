import 'package:flutter/material.dart';
import 'package:project_manager/components/customScrollBar.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/formIconButton.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/models/option.dart';
import 'package:project_manager/themes/dimens.dart';

class ModalPickerFormField extends StatefulWidget {
  const ModalPickerFormField({
    super.key,
    this.modalTitle,
    this.hintText,
    this.initialValue,
    required this.options,
    required this.onSelected,
    this.validator,
    this.suffixIcon,
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
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    if (_selectedValue != null) {
      _controller.text = widget.options
          .firstWhere((e) => e.value == _selectedValue)
          .label;
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
        selectedValue: _selectedValue,
        onSelected: (value) {
          widget.onSelected(value);
          setState(() => _selectedValue = value);
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
    required this.selectedValue,
    required this.onSelected,
    required this.controller,
    required this.scrollController,
  });

  final List<Option> options;
  final String? selectedValue;
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
          final isSelected = option.value == selectedValue;

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
                controller.text = option.label;

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
