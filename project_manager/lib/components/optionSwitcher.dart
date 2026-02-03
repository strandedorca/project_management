import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

// currently only supports two options
// 0 - first option
// 1 - second option
class OptionSwitcher extends StatefulWidget {
  const OptionSwitcher({
    super.key,
    required this.options,
    required this.onChanged,
  }) : assert(
         options.length == 2,
         'OptionSwitcher currently only supports two options',
       );

  final List<String> options;
  final ValueChanged<int> onChanged;

  @override
  State<OptionSwitcher> createState() => OptionSwitcherState();
}

class OptionSwitcherState extends State<OptionSwitcher> {
  bool isFirstOptionSelected = true;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.roundedBorderedBox(context, 999),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Invisible-text background part
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: isFirstOptionSelected
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: AnimatedContainer(
                height: double.infinity,
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingLarge,
                  vertical: AppDimens.spacingSmall,
                ),
                decoration: AppDecorations.roundedBorderedBox(
                  context,
                  999,
                ).copyWith(color: Theme.of(context).colorScheme.primary),
                child: Text(
                  isFirstOptionSelected ? widget.options[0] : widget.options[1],
                  style: const TextStyle(color: Colors.transparent),
                ),
              ),
            ),
          ),
          // Visible-text part
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(widget.options[0], () {
                setState(() {
                  isFirstOptionSelected = true;
                });
                widget.onChanged(0);
              }),
              _buildOption(widget.options[1], () {
                setState(() {
                  isFirstOptionSelected = false;
                });
                widget.onChanged(1);
              }),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildOption(String option, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLarge,
        vertical: AppDimens.spacingSmall,
      ),
      child: Text(option),
    ),
  );
}
