import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';

// A custom app bar with leading icon, title and trailing icon.
// Implements PreferredSizeWidget to ensure the app bar works with Scaffold.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;
  static const double _statusBarHeight = 40.0;

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
  @override
  Size get preferredSize => const Size.fromHeight(
    kToolbarHeight + verticalPadding * 2 + _statusBarHeight,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding + _statusBarHeight,
        horizontalPadding,
        verticalPadding,
      ),
      decoration: AppDecorations.bottomBorderedBoxDecoration(context),
      child: Row(
        children: [
          // Leading icon
          Container(
            width: 56,
            height: 56,
            decoration: AppDecorations.roundIconFrame(context),
            child: leading ?? const SizedBox.shrink(),
          ),
          // Title
          const SizedBox(width: 16),
          Expanded(child: title),
          // Trailing icon
          IconButton(
            padding: EdgeInsets.zero,
            icon: trailing ?? const SizedBox.shrink(),
            iconSize: 32,
            onPressed: () {
              // TODO: Open settings
              print('Open settings');
            },
          ),
        ],
      ),
    );
  }
}
