import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/dependencies.dart';
import 'package:project_manager/app/tasks_provider.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customDropdown.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/datePickerFormField.dart';
import 'package:project_manager/components/modalPickerFormField.dart';
import 'package:project_manager/components/tagPicker.dart';
import 'package:project_manager/components/taskList.dart';
import 'package:project_manager/data/models/option.dart';
import 'package:project_manager/data/models/priority_level.dart';
import 'package:project_manager/data/models/status.dart';
import 'package:project_manager/data/models/tag.dart';
import 'package:project_manager/pages/projects/projectCreationModel.dart';
import 'package:project_manager/pages/projects/projectDetailFormField.dart';
import 'package:project_manager/pages/tasks/taskCreationModal.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';

class ProjectDetailForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final ProjectCreationModel data;

  const ProjectDetailForm({
    super.key,
    required this.formKey,
    required this.data,
  });

  @override
  ConsumerState<ProjectDetailForm> createState() => _ProjectDetailFormState();
}

class _ProjectDetailFormState extends ConsumerState<ProjectDetailForm> {
  late List<Option> _categoryOptions = [];
  final List<Option> _statusOptions = Status.getOptions;
  final List<Option> _priorityOptions = PriorityLevel.getOptions;
  ProjectCreationModel get _data => widget.data;
  late final List<Tag> _allTags;
  final _deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTags();
    _deadlineController.text = _data.deadline != null
        ? DateFormatter.dateOnly(_data.deadline!)
        : '';
  }

  void _fetchCategories() {
    final categories = categoryService.getAllCategories();
    setState(() {
      _categoryOptions = categories
          .map((e) => Option.fromValues(e.id, e.name, Icons.folder_outlined))
          .toList();
      _data.categoryId = categories.isNotEmpty ? categories.first.id : '0';
    });
  }

  void _fetchTags() {
    final tags = tagService.getAllTags();
    setState(() {
      _allTags = tags;
    });
  }

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(projectTasksProvider(_data.id!));

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectDetailFormField(
            label: 'Name',
            childField: CustomTextFormField(
              initialValue: _data.name,
              validator: (value) => value != null && value.isEmpty
                  ? 'Project name is required'
                  : null,
              // TODO: pass the name when created to the onsaved
              onSaved: (value) => _data.name = value,
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectDetailFormField(
            label: 'Description',
            childField: CustomTextFormField(
              initialValue: _data.description,
              onSaved: (value) => _data.description = value,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          Row(
            children: [
              Expanded(
                child: ProjectDetailFormField(
                  label: 'Category',
                  hasSuffixIcon: true,
                  childField: ModalPickerFormField(
                    suffixIcon: Icons.folder_outlined,
                    modalTitle: 'Select Category',
                    options: _categoryOptions,
                    initialValue: _data.categoryId,
                    onSelected: (value) {
                      setState(() => _data.categoryId = value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spacingMedium),
              Expanded(
                child: ProjectDetailFormField(
                  label: 'Deadline',
                  hasSuffixIcon: true,
                  childField: DeadlinePickerFormField(
                    controller: _deadlineController,
                    value: _data.deadline,
                    onDateSelected: (date) {
                      setState(() => _data.deadline = date);
                    },
                    onClear: () {
                      setState(() {
                        _data.deadline = null;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          Row(
            children: [
              Expanded(
                child: ProjectDetailFormField(
                  label: 'Priority',
                  hasBorder: false,
                  childField: CustomDropdown(
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
              ),
              const SizedBox(width: AppDimens.spacingMedium),
              Expanded(
                child: ProjectDetailFormField(
                  label: 'Status',
                  hasBorder: false,
                  childField: CustomDropdown(
                    initialValue: _data.status?.value,
                    options: _statusOptions,
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
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectDetailFormField(
            label: 'Tags',
            hasBorder: false,
            childField: TagsPicker(
              allTags: _allTags,
              selectedTagIds: _data.tags ?? [],
              onTagsChanged: (tags) {
                setState(() {
                  _data.tags = tags;
                });
              },
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          // Task list
          ProjectDetailFormField(
            label: 'Tasks',
            hasBorder: false,
            childField: TaskList(tasks: tasks),
            action: Button(
              padding: EdgeInsets.symmetric(
                vertical: AppDimens.paddingSmall,
                horizontal: AppDimens.paddingMedium,
              ),
              borderRadius: AppDimens.borderRadiusSmall,
              onPressed: () =>
                  TaskCreationModal.showModal(context, parentId: _data.id),
              child: const Row(
                children: [
                  Icon(Icons.add, size: AppDimens.iconSmall),
                  SizedBox(width: AppDimens.spacingSmall),
                  Text('Add Task'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
