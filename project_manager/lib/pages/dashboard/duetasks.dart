import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';

class DueTasks extends StatelessWidget {
  const DueTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.redDebugBox(),
      child: Text('Due Tasks'),
    );
  }
}
