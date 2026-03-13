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
import 'package:project_manager/data/models/task.dart';
import 'package:project_manager/pages/tasks/taskCreationModel.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';

class TaskCreationModal extends ConsumerStatefulWidget {
  const TaskCreationModal({super.key, this.task, this.parentId});

  final Task? task;
  final String? parentId;

  static void showModal(BuildContext context, {Task? task, String? parentId}) {
    ModelBottomSheet.show(
      context,
      title: task != null ? 'Task Details' : 'New Task',
      TaskCreationModal(task: task, parentId: parentId),
      iconData: task != null ? Icons.delete_outline : null,
      onIconPressed: task != null
          ? () {
              ProviderScope.containerOf(
                context,
              ).read(tasksProvider.notifier).delete(task.id);
              Navigator.pop(context);
            }
          : null,
    );
  }

  @override
  ConsumerState<TaskCreationModal> createState() => _TaskCreationModalState();
}

class _TaskCreationModalState extends ConsumerState<TaskCreationModal> {
  final _formKey = GlobalKey<FormState>();
  late TaskCreationModel _data;
  final _deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _data = TaskCreationModel.fromTask(widget.task!);
      if (_data.deadline != null) {
        _deadlineController.text = DateFormatter.dateOnly(_data.deadline!);
      }
    } else {
      _data = TaskCreationModel();
      _data.parentId = widget.parentId ?? 'inbox';
    }
  }

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      if (widget.task != null) {
        ref.read(tasksProvider.notifier).update(_data.toTask(widget.task!.id));
      } else {
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
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('Failed to create/update task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create/update task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Option> priorityOptions = PriorityLevel.getOptions;
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
              autofocus: widget.task == null,
              onSaved: (value) => _data.name = value ?? '',
              validator: (value) => value != null && value.isEmpty
                  ? 'Task name is required'
                  : null,
              initialValue: _data.name,
            ),
            CustomTextFormField(
              hintText: 'Description',
              onSaved: (value) => _data.description = value ?? '',
              initialValue: _data.description,
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
            Button(
              onPressed: _handleSubmit,
              child: Text(widget.task != null ? 'Update Task' : 'Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
