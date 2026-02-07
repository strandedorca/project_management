import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String name;
  final double verticalPadding;
  final double horizontalPadding;
  final Color color;
  final bool hasBorder;

  const CustomChip({
    super.key,
    required this.name,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.color = Colors.transparent,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: hasBorder
            ? Border.all(color: Theme.of(context).colorScheme.outline)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(name, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
