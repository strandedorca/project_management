import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectDetailFormField extends StatelessWidget {
  const ProjectDetailFormField({
    super.key,
    this.label,
    required this.childField,
    this.hasBorder = true,
    this.hasSuffixIcon = false,
    this.action,
    this.onActionPressed,
  });

  final String? label;
  final Widget childField;
  final bool hasBorder;
  final bool hasSuffixIcon;
  final Widget? action;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!, style: Theme.of(context).textTheme.titleMedium),
              ?action,
            ],
          ),
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
