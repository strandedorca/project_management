import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/project_providers.dart';
import 'package:project_manager/app/providers.dart';
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
import 'package:project_manager/pages/projects/projectDetail.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCreationModal extends ConsumerStatefulWidget {
  const ProjectCreationModal({super.key});

  static Future<void> showModal(BuildContext context) {
    return ModelBottomSheet.show(
      context,
      'New Project',
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
  bool _loading = false;

  late List<Option> _categoryOptions = [];
  final List<Option> _priorityOptions = PriorityLevel.values
      .map((e) => Option.fromValues(e.value, e.label, null))
      .toList();
  final List<Option> _statusOptions = ProjectStatus.values
      .map((e) => Option.fromValues(e.value, e.label, null))
      .toList();
  late List<Option> _tagOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTags();
  }

  void _fetchCategories() {
    final categories = ref.read(categoryServiceProvider).getAllCategories();
    setState(() {
      _categoryOptions = categories
          .map((e) => Option.fromValues(e.id, e.name, Icons.folder_outlined))
          .toList();
      _data.categoryId = categories.isNotEmpty ? categories.first.id : '0';
    });
  }

  void _fetchTags() {
    final tags = ref.read(tagServiceProvider).getAllTags();
    setState(() {
      _tagOptions = tags
          .map((e) => Option.fromValues(e.id, e.name, Icons.tag_outlined))
          .toList();
    });
  }

  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save(); // onSaved callback
    setState(() => _loading = true);

    try {
      ref
          .read(projectsProvider.notifier)
          .add(
            name: _data.name!,
            description: _data.description,
            deadline: _data.deadline,
            categoryId: _data.categoryId ?? '1',
            priority: _data.priority,
            status: _data.status,
            tags: _data.tags ?? [],
          );

      final project = ref.read(projectsProvider).last;

      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProjectDetail(project: project)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      options: _categoryOptions,
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
                    options: _priorityOptions,
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
                    options: _statusOptions,
                    onSelected: (value) {
                      setState(
                        () => _data.status = ProjectStatus.values.firstWhere(
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
                options: _tagOptions,
                initialValues: _data.tags ?? [],
                suffixIcon: Icons.label_outlined,
              ),
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            Button(
              onPressed: _loading ? null : _handleSubmit,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
