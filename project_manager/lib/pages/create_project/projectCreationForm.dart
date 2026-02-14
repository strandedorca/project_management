import 'package:flutter/material.dart';
import 'package:project_manager/app/dependencies.dart';
import 'package:project_manager/components/categoryPickerFormField.dart';
import 'package:project_manager/components/customDropdown.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/datePickerFormField.dart';
import 'package:project_manager/components/optionSwitcher.dart';
import 'package:project_manager/components/paddedRoundedBorderedBox.dart';
import 'package:project_manager/components/tagPicker.dart';
import 'package:project_manager/models/category.dart';
import 'package:project_manager/models/importance_mode.dart';
import 'package:project_manager/models/option.dart';
import 'package:project_manager/models/priority_level.dart';
import 'package:project_manager/models/tag.dart';
import 'package:project_manager/pages/create_project/projectCreationFormField.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCreationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ProjectCreationForm({super.key, required this.formKey});

  @override
  State<ProjectCreationForm> createState() => _ProjectCreationFormState();
}

class _ProjectCreationFormState extends State<ProjectCreationForm> {
  late List<Category> _categories;
  String? _selectedCategoryId;
  DateTime? _selectedDate;
  late List<Tag> _allTags;
  List<String> _selectedTagIds = [];
  ImportanceMode _importanceMode = ImportanceMode.weight;
  String _selectedPriorityId = PriorityLevel.no.value;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTags();
  }

  void _fetchCategories() {
    final categories = categoryService.getAllCategories();
    setState(() {
      _categories = categories;
      _selectedCategoryId = _categories.isNotEmpty ? _categories.first.id : '0';
    });
  }

  void _fetchTags() {
    final tags = tagService.getAllTags();
    setState(() {
      _allTags = tags;
    });
  }

  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _weightController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Project name is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectCreationFormField(
            label: 'Name',
            childField: CustomTextFormField(
              controller: _nameController,
              validator: _nameValidator,
              autofocus: true,
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectCreationFormField(
            label: 'Description',
            childField: CustomTextFormField(
              controller: _descriptionController,
              // maxLines: 3,
              minLines: 3,
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          Row(
            children: [
              Expanded(
                child: ProjectCreationFormField(
                  label: 'Category',
                  hasSuffixIcon: true,
                  childField: ModalPickerFormField(
                    modalTitle: 'Select Category',
                    options: _categories
                        .map(
                          (e) => Option.fromValues(
                            e.id,
                            e.name,
                            Icons.folder_outlined,
                          ),
                        )
                        .toList(),
                    initialValue: _selectedCategoryId,
                    onSelected: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spacingMedium),
              Expanded(
                child: ProjectCreationFormField(
                  label: 'Deadline',
                  hasSuffixIcon: true,
                  childField: DeadlinePickerFormField(
                    controller: _deadlineController,
                    value: _selectedDate,
                    onDateSelected: (date) {
                      setState(() => _selectedDate = date);
                    },
                    onClear: () {
                      setState(() {
                        _selectedDate = null;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectCreationFormField(
            label: 'Tags',
            hasBorder: false,
            childField: TagsPicker(
              allTags: _allTags,
              selectedTagIds: _selectedTagIds,
              onTagsChanged: (tags) {
                setState(() {
                  _selectedTagIds = tags;
                });
              },
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectCreationFormField(
            label: 'Importance',
            hasBorder: false,
            childField: SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OptionSwitcher(
                    options: ImportanceMode.values.map((e) => e.label).toList(),
                    onChanged: (index) {
                      setState(() {
                        _importanceMode = index == 0
                            ? ImportanceMode.weight
                            : ImportanceMode.priority;
                      });
                    },
                  ),

                  const SizedBox(width: AppDimens.spacingMedium),
                  Expanded(
                    // TODO:retain the value of the weight/priority when the importance mode is changed
                    child: _importanceMode == ImportanceMode.weight
                        ? PaddedRoundedBorderedBox(
                            padding: EdgeInsets.only(
                              left: AppDimens.paddingMedium,
                            ),
                            borderRadius: 999,
                            child: CustomTextFormField(
                              controller: _weightController,
                              maxLines: 1,
                              suffixIcon: Icon(
                                Icons.percent_outlined,
                                color: Theme.of(context).colorScheme.outline,
                                size: AppDimens.iconSmall,
                              ),
                            ),
                          )
                        : CustomDropdown(
                            extraBottomSpace: 56,
                            initialValue: _selectedPriorityId,
                            options: PriorityLevel.values
                                .map(
                                  (e) =>
                                      Option.fromValues(e.value, e.label, null),
                                )
                                .toList(),
                            onSelected: (value) {
                              setState(() {
                                _selectedPriorityId = value;
                              });
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
