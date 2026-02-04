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

  // Rounded bordered rectangle shape
  static RoundedRectangleBorder roundedBorderedRectangleBorder(
    BuildContext context,
    double radius,
  ) {
    final colors = Theme.of(context).colorScheme;

    return RoundedRectangleBorder(
      side: BorderSide(
        color: colors.outline,
        width: AppDimens.borderWidthMedium,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static InputDecoration borderlessInputDecoration(BuildContext context) =>
      const InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      );

  // Rounded bordered input border
  static InputDecoration roundedBorderedInputBorder(
    BuildContext context,
    double radius,
  ) => InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline,
        width: AppDimens.borderWidthMedium,
      ),
      borderRadius: BorderRadius.circular(radius),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline,
        width: AppDimens.borderWidthMedium,
      ),
      borderRadius: BorderRadius.circular(radius),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: AppDimens.borderWidthMedium,
      ),
      borderRadius: BorderRadius.circular(radius),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: AppDimens.borderWidthMedium,
      ),
      borderRadius: BorderRadius.circular(radius),
    ),
  );

  // Red debug containers
  static BoxDecoration redDebugBox() {
    return BoxDecoration(color: Colors.red);
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
