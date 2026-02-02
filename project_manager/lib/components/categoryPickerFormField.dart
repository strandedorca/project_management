import 'package:flutter/material.dart';
import 'package:project_manager/components/borderlessTextFormField.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/models/category.dart';
import 'package:project_manager/themes/dimens.dart';

class CategoryPickerFormField extends StatelessWidget {
  const CategoryPickerFormField({
    super.key,
    required this.controller,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.validator,
  });

  final TextEditingController controller;
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<Category> onCategorySelected;
  final String? Function(String?)? validator;

  void _showPicker(BuildContext context) {
    ModelBottomSheet.show(
      context,
      'Select Category',
      _CategoryPickerSheetContent(
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        onCategorySelected: onCategorySelected,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BorderlessTextFormField(
      controller: controller,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      validator: validator,
      onTap: () => _showPicker(context),
      suffixIcon: IconButton(
        icon: Icon(
          Icons.folder_outlined,
          color: Theme.of(context).colorScheme.outline,
        ),
        onPressed: () => _showPicker(context),
      ),
    );
  }
}

class _CategoryPickerSheetContent extends StatelessWidget {
  const _CategoryPickerSheetContent({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.controller,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<Category> onCategorySelected;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category.id == selectedCategoryId;

        return Container(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
              : null,
          child: ListTile(
            leading: Icon(
              (category.icon ?? Icons.folder_outlined) as IconData?,
              color: Theme.of(context).colorScheme.outline,
            ),
            title: Text(
              category.name,
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
              // Update the controller text and call the onCategorySelected callback
              controller.text = category.name;
              onCategorySelected(category);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
