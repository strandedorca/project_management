import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

final EdgeInsets _padding = EdgeInsets.all(AppDimens.spacingSmall);
final double _height = 40;

class FullWidthSwitcher extends StatefulWidget {
  const FullWidthSwitcher({
    super.key,
    required this.options,
    required this.onChanged,
  });

  final List<String> options;
  final ValueChanged<int> onChanged;

  @override
  State<FullWidthSwitcher> createState() => FullWidthSwitcherState();
}

class FullWidthSwitcherState extends State<FullWidthSwitcher> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: AppDecorations.roundedBorderedRectangleBorder(context, 999),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / widget.options.length;
          final indicatorLeft = _selectedIndex * segmentWidth;

          return Stack(
            children: [
              // Active option indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                top: 0,
                left: indicatorLeft,
                width: segmentWidth,
                child: Container(
                  height: _height,
                  padding: _padding,
                  decoration: AppDecorations.roundedBorderedBox(
                    context,
                    999,
                  ).copyWith(color: Theme.of(context).colorScheme.primary),
                  child: Text(
                    '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.transparent),
                  ),
                ),
              ),

              // Option text
              Row(
                children: [
                  ...widget.options.map(
                    (option) => _buildOption(option, context, () {
                      setState(() {
                        _selectedIndex = widget.options.indexOf(option);
                      });
                      widget.onChanged(_selectedIndex);
                    }),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildOption(String option, BuildContext context, VoidCallback onTap) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: _height,
        padding: _padding,
        child: Center(
          child: Text(
            option,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
  );
}
