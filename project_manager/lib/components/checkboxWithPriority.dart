import 'package:flutter/material.dart';
import 'package:project_manager/data/models/priority_level.dart';

class CheckboxWithPriority extends StatelessWidget {
  final PriorityLevel priority;
  final double size;
  final double borderWidth;
  final bool isChecked;
  const CheckboxWithPriority({
    super.key,
    required this.priority,
    required this.size,
    required this.borderWidth,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: priority.borderColor, width: borderWidth),
            color: priority.color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
        if (isChecked) Icon(Icons.check, size: size - 5),
      ],
    );
  }
}
