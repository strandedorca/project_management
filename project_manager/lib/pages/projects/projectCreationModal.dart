import 'package:flutter/material.dart';
import 'package:project_manager/app/dependencies.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customDropdown.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/datePickerFormField.dart';
import 'package:project_manager/components/formFieldWrapper.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/components/modalPickerFormField.dart';
import 'package:project_manager/models/option.dart';
import 'package:project_manager/models/priority_level.dart';
import 'package:project_manager/pages/projects/projectCreationModel.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCreationModal extends StatefulWidget {
  const ProjectCreationModal({super.key});

  static void showModal(BuildContext context) {
    ModelBottomSheet.show(context, 'New Project', ProjectCreationModal());
  }

  @override
  State<ProjectCreationModal> createState() => _ProjectCreationModalState();
}

class _ProjectCreationModalState extends State<ProjectCreationModal> {
  final _formKey = GlobalKey<FormState>();
  final _data = ProjectCreationModel();
  bool _loading = false;

  late List<Option> _categoryOptions = [];
  String? _selectedCategoryId;
  DateTime? _selectedDate;
  String? _selectedPriorityValue;
  final List<Option> _priorityOptions = PriorityLevel.values
      .map((e) => Option.fromValues(e.value, e.label, null))
      .toList();
  String? _selectedStatusValue;
  final List<Option> _statusOptions = [
    Option.fromValues('not_started', 'Not Started', Icons.check_circle_outline),
    Option.fromValues('in_progress', 'In Progress', Icons.check_circle_outline),
    Option.fromValues('completed', 'Completed', Icons.check_circle_outline),
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    final categories = categoryService.getAllCategories();
    setState(() {
      _categoryOptions = categories
          .map((e) => Option.fromValues(e.id, e.name, Icons.folder_outlined))
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
    _formKey.currentState!.save();
    print('Form is valid! Creating task...');

    setState(() => _loading = true);

    try {
      await Future.delayed(Duration(seconds: 1)); // fake API
      print(_data.name);
      print(_data.description);
      print(_data.categoryId);
      print(_data.deadline);
      print(_data.priority);
      print(_data.status);
    } finally {
      setState(() => _loading = false);
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
                      modalTitle: 'Select Category',
                      hintText: 'Category',
                      options: _categoryOptions,
                      initialValue: _selectedCategoryId,
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
                      value: _selectedDate,
                      onDateSelected: (date) {
                        setState(() => _selectedDate = date);
                        _data.deadline = date;
                      },
                      onClear: () {
                        setState(() {
                          _selectedDate = null;
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
                    initialValue: _selectedPriorityValue,
                    options: _priorityOptions,
                    onSelected: (value) {
                      setState(() {
                        _selectedPriorityValue = value;
                        _data.priority = value;
                      });
                    },
                    suffixIcon: Icons.flag_outlined,
                  ),
                ),
                const SizedBox(width: AppDimens.spacingMedium),
                Expanded(
                  child: CustomDropdown(
                    hintText: 'Status',
                    initialValue: _selectedStatusValue,
                    options: _statusOptions,
                    onSelected: (value) {
                      setState(() {
                        _selectedStatusValue = value;
                        _data.status = value;
                      });
                    },
                    suffixIcon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            Button(
              onPressed: _loading ? null : _handleSubmit,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
