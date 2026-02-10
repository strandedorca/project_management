import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  final bool isExpanded;
  final VoidCallback onTap;

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: AppDecorations.roundedBorderedRectangleBorder(
        context,
        widget.isExpanded ? AppDimens.borderRadiusMedium : 999,
      ),
      clipBehavior: Clip.hardEdge,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: widget.isExpanded
            ? SizedBox(
                width: 156,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOption(
                      context,
                      Icons.check_circle_outline,
                      'New task',
                      widget.onTap,
                    ),
                    _buildOption(
                      context,
                      Icons.folder_open_rounded,
                      'New project',
                      widget.onTap,
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(AppDimens.paddingExtraSmall),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    widget.onTap();
                  },
                ),
              ),
      ),
    );
  }
}

Widget _buildOption(
  BuildContext context,
  IconData icon,
  String label,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.all(AppDimens.paddingMedium),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(width: AppDimens.spacingSmall),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ),
  );
}
