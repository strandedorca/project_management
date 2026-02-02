import 'package:flutter/material.dart';
import 'package:project_manager/components/borderlessTextFormField.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';

class DeadlinePickerFormField extends StatelessWidget {
  const DeadlinePickerFormField({
    super.key,
    required this.controller,
    required this.onDateSelected,
    this.value,
    this.onClear,
    this.validator,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final DateTime? value;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onClear;

  Future<void> _openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // Selected date when the picker is opened
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      // Customize the date picker widget (`child` is the default date picker widget)
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: DialogThemeData(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: AppDecorations.roundedBorderedRectangleBorder(
              context,
              AppDimens.borderRadiusMedium,
            ),
            elevation: 0,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      // Update the controller text and call the onDateSelected callback
      controller.text = DateFormatter.dateOnly(picked);
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return BorderlessTextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      validator: validator,
      readOnly: true,
      onTap: () => _openDatePicker(context),
      suffixIcon: hasValue && onClear != null
          ? IconButton(
              icon: Icon(
                Icons.cancel_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
              onPressed: () {
                controller.clear();
                onClear?.call();
              },
            )
          : IconButton(
              icon: Icon(
                Icons.calendar_month_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
              onPressed: () => _openDatePicker(context),
            ),
    );
  }
}
