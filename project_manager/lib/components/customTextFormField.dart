import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

/// CustomTextFormField is a styled wrapper around TextFormField that applies consistent styling & simplified configuration.
///
/// This widget:
/// - Uses the app's 'bodyMedium' text style for the input text.
/// - Applies a custom borderless decoration from [AppDecorations].
/// - Sets a consistent cursor color.
/// - Supports commonly used [TextFormField] properties

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.suffixIcon,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.textAlignVertical = TextAlignVertical.center,
    this.onTap,
    this.onSaved,
    this.hintText,
    this.fontSize = 16,
    this.contentPadding,
    this.suffixIconConstraints = const BoxConstraints(
      maxWidth: AppDimens.formFieldSize,
    ),
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool autofocus;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextAlignVertical textAlignVertical;
  final VoidCallback? onTap;
  final void Function(String?)? onSaved;
  final String? hintText;
  final double fontSize;
  final EdgeInsets? contentPadding;
  final BoxConstraints suffixIconConstraints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
      cursorColor: Theme.of(context).colorScheme.outline,
      decoration: AppDecorations.borderlessInputDecoration(context).copyWith(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: fontSize),
        contentPadding: contentPadding,
        suffixIconConstraints: suffixIconConstraints,
      ),
      textAlignVertical: textAlignVertical,
      controller: controller,
      validator: validator,
      autofocus: autofocus,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      onTap: onTap,
      onSaved: onSaved,
    );
  }
}
