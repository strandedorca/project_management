import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';

class CustomCheckbox extends StatelessWidget {
  final double size;

  const CustomCheckbox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: AppDecorations.roundedBorderedBox(context, 2.0),
    );
  }
}
