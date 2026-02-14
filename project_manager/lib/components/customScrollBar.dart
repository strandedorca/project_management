import 'package:flutter/material.dart';
import 'package:project_manager/themes/dimens.dart';

/// CustomScrollBar is a scrollbar that can be used to scroll a widget.
/// It is a wrapper around [RawScrollbar] to provide a consistent styling.
///
/// ## Parameters
/// - (required) [child]: The widget to scroll.
/// - (required) [controller]: The mutual controller of the scrollbar and the widget to scroll.

class CustomScrollBar extends StatelessWidget {
  const CustomScrollBar({
    super.key,
    required this.child,
    required this.controller,
  });

  final Widget child;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      padding: EdgeInsets.zero,
      thumbColor: Theme.of(context).colorScheme.primary,
      thickness: AppDimens.spacingSmall,
      thumbVisibility: true,
      interactive: true,
      shape: StadiumBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
