import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

/// A text field with a trailing icon that opens a category picker bottom sheet
class CategoryPickerField extends StatelessWidget {
  const CategoryPickerField({
    super.key,
    required this.controller,
    required this.onCategorySelected,
    this.validator,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCategorySelected;
  final String? Function(String?)? validator;

  // Sample categories - in a real app, this would come from a service/repository
  static const List<String> categories = [
    'Work',
    'Personal',
    'School',
    'Health',
    'Finance',
    'Travel',
    'Other',
  ];

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.borderRadiusMedium),
        ),
      ),
      builder: (context) => _CategoryPickerSheet(
        categories: categories,
        onCategorySelected: (category) {
          controller.text = category;
          onCategorySelected(category);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Prevent manual typing
      cursorColor: Theme.of(context).colorScheme.outline,
      validator: validator,
      onTap: () => _showCategoryPicker(context),
      decoration:
          AppDecorations.roundedBorderedInputBorder(
            context,
            AppDimens.borderRadiusSmall,
          ).copyWith(
            suffixIcon: IconButton(
              icon: Icon(Icons.folder_outlined),
              onPressed: () => _showCategoryPicker(context),
            ),
          ),
    );
  }
}

class _CategoryPickerSheet extends StatelessWidget {
  const _CategoryPickerSheet({
    required this.categories,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.appPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Category',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ...categories.map(
            (category) => ListTile(
              leading: Icon(Icons.folder_outlined),
              title: Text(category),
              onTap: () => onCategorySelected(category),
            ),
          ),
          const SizedBox(height: AppDimens.spacingSmall),
        ],
      ),
    );
  }
}
