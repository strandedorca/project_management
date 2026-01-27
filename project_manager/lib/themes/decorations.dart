import 'package:flutter/material.dart';
import 'package:project_manager/themes/dimens.dart';

class AppDecorations {
  // Bottom bordered decoration for containers
  static BoxDecoration bottomBorderedBoxDecoration(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: colors.outline,
          width: AppDimens.borderWidthMedium,
        ),
      ),
    );
  }

  // Rounded bordered decoration for containers
  static BoxDecoration roundedBorderedBox(BuildContext context, double radius) {
    final colors = Theme.of(context).colorScheme;

    return BoxDecoration(
      border: Border.all(
        color: colors.outline,
        width: AppDimens.borderWidthMedium,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // Red debug containers
  static BoxDecoration redDebugBox() {
    return BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
    );
  }

  // Round icon frame decoration
  static BoxDecoration roundIconFrame(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BoxDecoration(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: colors.outline,
        width: AppDimens.borderWidthMedium,
      ),
    );
  }
}
