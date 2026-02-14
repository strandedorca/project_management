import 'package:flutter/material.dart';
import 'package:project_manager/app/dependencies.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customDropdown.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/datePickerFormField.dart';
import 'package:project_manager/components/formFieldWrapper.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/components/modalPickerFormField.dart';
import 'package:project_manager/components/multiModalPickerFormField.dart';
import 'package:project_manager/models/option.dart';
import 'package:project_manager/models/priority_level.dart';
import 'package:project_manager/pages/tasks/taskCreationModel.dart';
import 'package:project_manager/themes/dimens.dart';

class TaskCreationModal extends StatefulWidget {
  const TaskCreationModal({super.key});

  static void showModal(BuildContext context) {
    ModelBottomSheet.show(
      context,
      'New Task',
      TaskCreationModal(),
      actionIcon: IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.open_in_new),
        onPressed: () => print('open in new tab pressed'),
      ),
    );
  }

  @override
  State<TaskCreationModal> createState() => _TaskCreationModalState();
}

class _TaskCreationModalState extends State<TaskCreationModal> {
  final _formKey = GlobalKey<FormState>();
  final _data = TaskCreationModel();
  bool _loading = false;
  // TODO: Categories are just parent projects
  late List<Option> _categoryOptions;
  String? _selectedCategoryId;
  DateTime? _selectedDate;
  late List<Option> _tagOptions;
  List<String> _selectedTagValues = [];
  String? _selectedPriorityValue;
  final List<Option> _priorityOptions = PriorityLevel.values
      .map((e) => Option.fromValues(e.value, e.label, null))
      .toList();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTags();
  }

  void _fetchCategories() {
    final categories = categoryService.getAllCategories();
    setState(() {
      _categoryOptions = categories
          .map((e) => Option.fromValues(e.id, e.name, Icons.folder_outlined))
          .toList();
    });
  }

  void _fetchTags() {
    final tags = tagService.getAllTags();
    setState(() {
      _tagOptions = tags
          .map((e) => Option.fromValues(e.id, e.name, Icons.label_outlined))
          .toList();
    });
  }

  //  TODO:replace controllers with data model
  // Controllers
  final _categoryController = TextEditingController();
  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
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
      print(_data.projectId);
      print(_data.deadline);
      print(_data.priority);
      print(_data.tags);
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
                        _data.projectId = value;
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
                // TODO: add a reminder picker form field
                Expanded(
                  child: FormFieldWrapper(
                    childField: CustomTextFormField(
                      hintText: 'Reminder',
                      onTap: () => print('reminder shown'),
                      readOnly: true,
                    ),
                    suffixIcon: Icons.access_alarm_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingMedium),
            Row(
              children: [
                Expanded(
                  child: FormFieldWrapper(
                    childField: MultiModalPickerFormField(
                      hintText: 'Tags',
                      modalTitle: 'Select Tags',
                      onSelected: (value) {
                        setState(() {
                          _selectedTagValues.add(value);
                        });
                      },
                      options: _tagOptions,
                      initialValues: _selectedTagValues,
                      suffixIcon: Icons.label_outlined,
                    ),
                    childHasSuffixIcon: true,
                  ),
                ),
                const SizedBox(width: AppDimens.spacingMedium),
                Expanded(
                  child: FormFieldWrapper(
                    childField: CustomTextFormField(
                      hintText: 'Date',
                      onTap: () => print('date picker shown'),
                      readOnly: true,
                    ),
                    suffixIcon: Icons.calendar_month_outlined,
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
