import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';

// A custom app bar with leading icon, title and trailing icon.
// Implements PreferredSizeWidget to ensure the app bar works with Scaffold.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;

  // Constructor
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.leadingOnTap,
    this.trailingOnTap,
  });
  final Widget title;
  final Widget? leading;
  final VoidCallback? leadingOnTap;
  final Widget? trailing;
  final VoidCallback? trailingOnTap;

  // preferredSize is a required getter to implement PreferredSizeWidget.
  // SafeArea wraps Scaffold, so AppBar doesn't need status bar padding
  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + verticalPadding * 2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: AppDecorations.bottomBorderedBoxDecoration(context),
      child: Row(
        children: [
          // Tappable leading icon
          if (leading != null)
            Material(
              shape: AppDecorations.roundedBorderedRectangleBorder(
                context,
                999,
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap:
                    leadingOnTap ??
                    () {
                      print('Leading icon pressed');
                    },
                // borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: AppDecorations.roundIconFrame(context),
                  child: leading,
                ),
              ),
            ),
          // Title
          const SizedBox(width: 16),
          Expanded(child: title),
          // Trailing icon
          if (trailing != null)
            IconButton(
              padding: EdgeInsets.zero,
              icon: trailing!,
              iconSize: 32,
              onPressed:
                  trailingOnTap ??
                  () {
                    // TODO: Default trailing action
                    print('Trailing icon pressed');
                  },
            ),
        ],
      ),
    );
  }
}
