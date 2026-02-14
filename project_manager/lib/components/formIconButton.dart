import 'package:flutter/material.dart';
import 'package:project_manager/themes/dimens.dart';

/// FormIconButton is a styled icon button for form fields.
/// It provides a consistent look for icon buttons in form fields.
///
/// ## Parameters:
/// - (required) [iconData] The icon to be displayed.
/// - (required) [onPressed] The callback to be called when the icon is pressed.

class FormIconButton extends StatelessWidget {
  const FormIconButton({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        maxWidth: AppDimens.formFieldSize,
        minWidth: AppDimens.formFieldSize,
        maxHeight: AppDimens.formFieldSize,
        minHeight: AppDimens.formFieldSize,
      ),
      iconSize: 24,
      icon: Icon(iconData, color: Theme.of(context).colorScheme.outline),
      onPressed: onPressed,
    );
  }
}
