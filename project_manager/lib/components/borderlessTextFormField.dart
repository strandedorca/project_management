import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';

class BorderlessTextFormField extends StatelessWidget {
  const BorderlessTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.suffixIcon,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.textAlignVertical,
    this.onTap,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool autofocus;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyMedium,
      cursorColor: Theme.of(context).colorScheme.outline,
      textAlignVertical: textAlignVertical,
      controller: controller,
      validator: validator,
      autofocus: autofocus,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      decoration: AppDecorations.borderlessInputDecoration(
        context,
      ).copyWith(suffixIcon: suffixIcon),
      onTap: onTap,
    );
  }
}
