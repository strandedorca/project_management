import 'package:flutter/material.dart';
import 'package:project_manager/components/formIconButton.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

/// FormFieldWrapper is a wrapper for form fields.
/// It provides a consistent look for form fields with rounded borders and padding.
/// - This wrapper only allows for one line of text.
/// - The suffix icon can come either from this wrapper or
///   from the child field. In both cases, [FormIconButton]
///   is used to keep styling consistent.
///
/// ## Parameters:
/// - (required) [childField] The main content of the container.
/// - [label] The label to be displayed above the container.
/// - [suffixIcon] The icon to be displayed on the right side of the container.
/// - [onSuffixIconPressed] The callback to be called when the suffix icon is pressed.
/// - [hasBorder] Whether the container has a border.
/// - [childHasSuffixIcon] Whether the child has a suffix icon.

class FormFieldWrapper extends StatelessWidget {
  const FormFieldWrapper({
    super.key,
    required this.childField,
    this.label,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.hasBorder = true,
    this.childHasSuffixIcon = false,
  });

  final Widget childField;
  final String? label;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool hasBorder;
  final bool childHasSuffixIcon;

  @override
  Widget build(BuildContext context) {
    final hasSuffixIcon = childHasSuffixIcon || suffixIcon != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// (Optional) Label
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppDimens.spacingMedium),
        ],

        /// Content
        Container(
          padding:
              hasBorder // Border means there is a padding
              ? EdgeInsets.only(
                  right: hasSuffixIcon
                      ? 0
                      : AppDimens.paddingSmall + AppDimens.spacingExtraSmall,
                  left: AppDimens.paddingSmall + AppDimens.spacingExtraSmall,
                )
              : null,
          decoration: hasBorder
              ? AppDecorations.roundedBorderedBox(
                  context,
                  AppDimens.borderRadiusSmall,
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: AppDimens.formFieldSize,
                  child: Center(child: childField),
                ),
              ),
              if (suffixIcon != null)
                FormIconButton(
                  iconData: suffixIcon!,
                  onPressed: onSuffixIconPressed ?? () {},
                ),
            ],
          ),
        ),
      ],
    );
  }
}
