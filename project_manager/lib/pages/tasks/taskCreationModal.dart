import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/projects_provider.dart';
import 'package:project_manager/app/tasks_provider.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customDropdown.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/datePickerFormField.dart';
import 'package:project_manager/components/formFieldWrapper.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/components/modalPickerFormField.dart';
import 'package:project_manager/data/models/option.dart';
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/pages/tasks/taskCreationModel.dart';
import 'package:project_manager/themes/dimens.dart';

class TaskCreationModal extends ConsumerStatefulWidget {
  const TaskCreationModal({super.key});

  static void showModal(BuildContext context) {
    ModelBottomSheet.show(context, title: 'New Task', TaskCreationModal());
  }

  @override
  ConsumerState<TaskCreationModal> createState() => _TaskCreationModalState();
}

class _TaskCreationModalState extends ConsumerState<TaskCreationModal> {
  final _formKey = GlobalKey<FormState>();
  final _data = TaskCreationModel();
  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      ref
          .read(tasksProvider.notifier)
          .add(
            name: _data.name!,
            parentId: _data.parentId,
            description: _data.description,
            dueDate: _data.deadline,
            status: _data.status,
            priority: _data.priority,
          );
      print('Task created: ${_data.name}');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('Failed to create project: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create project: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Option> priorityOptions = PriorityLevel.getOptions;
    final List<Option> statusOptions = Status.getOptions;
    final List<Option> projectOptions = ref.watch(projectOptionsProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: 'Task Name',
              fontSize: 20.0,
              autofocus: true,
              onSaved: (value) => _data.name = value ?? '',
              validator: (value) => value != null && value.isEmpty
                  ? 'Task name is required'
                  : null,
            ),
            CustomTextFormField(
              hintText: 'Description',
              onSaved: (value) => _data.description = value ?? '',
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            Row(
              children: [
                Expanded(
                  child: FormFieldWrapper(
                    childField: ModalPickerFormField(
                      suffixIcon: Icons.folder_outlined,
                      modalTitle: 'Select Project',
                      hintText: 'Project',
                      options: projectOptions,
                      initialValue: _data.parentId,
                      onSelected: (value) {
                        _data.parentId = value;
                      },
                    ),
                    childHasSuffixIcon: true,
                  ),
                ),
                const SizedBox(width: AppDimens.spacingMedium),
                Expanded(
                  child: FormFieldWrapper(
                    childField: DeadlinePickerFormField(
                      controller: _deadlineController,
                      value: _data.deadline,
                      onDateSelected: (date) {
                        setState(() => _data.deadline = date);
                        _data.deadline = date;
                      },
                      onClear: () {
                        setState(() {
                          _data.deadline = null;
                        });
                      },
                    ),
                    childHasSuffixIcon: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    hintText: 'Priority',
                    initialValue: _data.priority?.value,
                    options: priorityOptions,
                    onSelected: (value) {
                      setState(() {
                        _data.priority = PriorityLevel.values.firstWhere(
                          (e) => e.value == value,
                        );
                      });
                    },
                    suffixIcon: Icons.flag_outlined,
                  ),
                ),
                const SizedBox(width: AppDimens.spacingMedium),
                Expanded(child: SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            Button(onPressed: _handleSubmit, child: Text('Create Task')),
          ],
        ),
      ),
    );
  }
}
