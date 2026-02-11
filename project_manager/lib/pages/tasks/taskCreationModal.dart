import 'package:flutter/material.dart';
import 'package:project_manager/components/modalBottomSheet.dart';

class TaskCreationModal extends StatelessWidget {
  const TaskCreationModal({super.key});

  static void showModal(BuildContext context) {
    ModelBottomSheet.show(context, 'Create Task', TaskCreationModal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Create Task'));
  }
}
