import 'package:flutter/material.dart';
import 'package:project_manager/themes/colors.dart';

enum PriorityLevel {
  no('no_priority', 'No Priority', Colors.white, AppColors.grey),
  low('low_priority', 'Low', AppColors.blue, AppColors.blue),
  medium('medium_priority', 'Medium', AppColors.green, AppColors.green),
  high('high_priority', 'High', AppColors.error, AppColors.error);

  final String value;
  final String label;
  final Color color;
  final Color borderColor;

  const PriorityLevel(this.value, this.label, this.color, this.borderColor);
}
