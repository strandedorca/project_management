import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCreationFormField extends StatelessWidget {
  const ProjectCreationFormField({
    super.key,
    this.label,
    required this.childField,
    this.hasBorder = true,
    this.hasSuffixIcon = false,
  });

  final String? label;
  final Widget childField;
  final bool hasBorder;
  final bool hasSuffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (label != null)
          Text(label!, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppDimens.spacingMedium),
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
          child: childField,
        ),
      ],
    );
  }
}
