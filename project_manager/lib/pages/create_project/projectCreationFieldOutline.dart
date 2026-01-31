import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCreationFieldOutline extends StatelessWidget {
  const ProjectCreationFieldOutline({
    super.key,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int minLines;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      cursorColor: Theme.of(context).colorScheme.outline,
      maxLines: maxLines,
      minLines: minLines,
      decoration: AppDecorations.roundedBorderedInputBorder(
        context,
        AppDimens.borderRadiusSmall,
      ),
    );
  }
}
