import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/categories_provider.dart';
import 'package:project_manager/app/projects_provider.dart';
import 'package:project_manager/app/tags_provider.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customDropdown.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/datePickerFormField.dart';
import 'package:project_manager/components/formFieldWrapper.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/components/modalPickerFormField.dart';
import 'package:project_manager/components/multiModalPickerFormField.dart';
import 'package:project_manager/data/models/option.dart';
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/pages/projects/projectCreationModel.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCreationModal extends ConsumerStatefulWidget {
  const ProjectCreationModal({super.key});

  static Future<void> showModal(BuildContext context) {
    return ModelBottomSheet.show(
      context,
      title: 'New Project',
      ProjectCreationModal(),
    );
  }

  @override
  ConsumerState<ProjectCreationModal> createState() =>
      _ProjectCreationModalState();
}

class _ProjectCreationModalState extends ConsumerState<ProjectCreationModal> {
  final _formKey = GlobalKey<FormState>();
  final _data = ProjectCreationModel();
  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save(); // onSaved callback

    try {
      ref
          .read(projectsProvider.notifier)
          .add(
            name: _data.name!,
            description: _data.description,
            deadline: _data.deadline,
            categoryId: _data.categoryId,
            priority: _data.priority,
            status: _data.status,
            tags: _data.tags ?? [],
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create project: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Option> priorityOptions = PriorityLevel.getOptions;
    final List<Option> statusOptions = Status.getOptions;
    final List<Option> categoryOptions = ref.watch(categoryOptionsProvider);
    final List<Option> tagOptions = ref.watch(tagOptionsProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: 'Project Name',
              fontSize: 20.0,
              autofocus: true,
              onSaved: (value) => _data.name = value ?? '',
              validator: (value) => value != null && value.isEmpty
                  ? 'Project name is required'
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
                      modalTitle: 'Select Category',
                      hintText: 'Category',
                      options: categoryOptions,
                      initialValue: _data.categoryId,
                      onSelected: (value) {
                        _data.categoryId = value;
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
                      },
                      onClear: () {
                        setState(() => _data.deadline = null);
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
                Expanded(
                  child: CustomDropdown(
                    hintText: 'Status',
                    initialValue: _data.status?.value,
                    options: statusOptions,
                    onSelected: (value) {
                      setState(
                        () => _data.status = Status.values.firstWhere(
                          (e) => e.value == value,
                        ),
                      );
                    },
                    suffixIcon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            FormFieldWrapper(
              childField: MultiModalPickerFormField(
                hintText: 'Tags',
                modalTitle: 'Select Tags',
                onSelected: (values) {
                  setState(() => _data.tags = values);
                },
                options: tagOptions,
                initialValues: _data.tags ?? [],
                suffixIcon: Icons.label_outlined,
              ),
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            Button(
              onPressed: _handleSubmit,
              child: const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
