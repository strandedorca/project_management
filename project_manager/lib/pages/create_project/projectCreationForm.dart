import 'package:flutter/material.dart';
import 'package:project_manager/models/category.dart';
import 'package:project_manager/pages/create_project/projectCreationFormField.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/date_formatter.dart';

class ProjectCreationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ProjectCreationForm({super.key, required this.formKey});

  @override
  State<ProjectCreationForm> createState() => _ProjectCreationFormState();
}

class _ProjectCreationFormState extends State<ProjectCreationForm> {
  // Form field controllers to access values
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _tagsController = TextEditingController();

  List<Category> _categories = [];
  String? _selectedCategory;
  DateTime? _selectedDate;
  List<String> _availableTags = [];
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTags();
  }

  void _fetchCategories() {
    // Sample categories - TODO: replace with API call
    // TODO: Add icons to categories
    final List<Category> categories = [
      Category(id: '1', name: 'Inbox'), // Default category
      Category(id: '2', name: 'Work'),
      Category(id: '3', name: 'Personal'),
      Category(id: '4', name: 'School'),
      Category(id: '5', name: 'Health'),
      Category(id: '6', name: 'Finance'),
      Category(id: '7', name: 'Travel'),
      Category(id: '8', name: 'Other'),
    ];
    setState(() {
      _categories = categories;
      _selectedCategory = 'Inbox';
    });
  }

  void _fetchTags() {
    // Sample tags - TODO: replace with API call
    final List<String> tags = [
      'Ambi',
      'Blender',
      'Cinema 4D',
      'Maya',
      'Substance Painter',
      'Substance Designer',
      'Substance Render',
      'Substance Matte',
      'Substance Normal',
      'Substance Displacement',
      'Substance Height',
      'Substance Roughness',
      'Substance Metallic',
      'Substance Ambient Occlusion',
    ];
    setState(() {
      _availableTags = tags;
    });
  }

  // Dispose of the controllers when the form is removed from the tree
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  // Validators
  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Project name is required';
    }
    return null;
  }

  Future<void> _selectDeadline() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: DialogThemeData(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: AppDecorations.roundedBorderedRectangleBorder(
              context,
              AppDimens.borderRadiusMedium,
            ),
            elevation: 0,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _deadlineController.text = DateFormatter.dateOnly(picked!);
      });
      print('Deadline selected: ${_deadlineController.text}');
    }
  }

  void _clearDeadline() {
    setState(() {
      _selectedDate = null;
      _deadlineController.text = '';
    });
    print('Deadline cleared: ${_deadlineController.text}');
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: AppDecorations.roundedBorderedRectangleBorder(
        context,
        AppDimens.borderRadiusMedium,
      ),
      builder: (context) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimens.appPadding),
              decoration: AppDecorations.bottomBorderedBoxDecoration(context),
              width: double.infinity,
              child: Text(
                'Select Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ..._categories.map(
                        (category) => Container(
                          color: category.name == _selectedCategory
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.5)
                              : null,
                          child: ListTile(
                            // TODO: Add icons to categories - default to folder_outlined if no icon provided
                            leading: Icon(
                              Icons.folder_outlined,
                              color: Theme.of(context).colorScheme.outline,
                            ),

                            title: Text(
                              category.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: category.name == _selectedCategory
                                ? Icon(
                                    Icons.check,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  )
                                : null,
                            horizontalTitleGap: AppDimens.spacingMedium,
                            minLeadingWidth: 0,
                            onTap: () {
                              setState(() {
                                _selectedCategory = category.name;
                                _categoryController.text = _selectedCategory!;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          ProjectCreationFormField(
            label: 'Name',
            childField: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              autofocus: true,
              cursorColor: Theme.of(context).colorScheme.outline,
              controller: _nameController,
              validator: _nameValidator,
              decoration: AppDecorations.borderlessInputDecoration(context),
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectCreationFormField(
            label: 'Description',
            childField: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              cursorColor: Theme.of(context).colorScheme.outline,
              controller: _descriptionController,
              maxLines: 3,
              minLines: 3,
              decoration: AppDecorations.borderlessInputDecoration(context),
            ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          Row(
            children: [
              Expanded(
                child: ProjectCreationFormField(
                  label: 'Category',
                  hasSuffixIcon: true,
                  childField: TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlignVertical: TextAlignVertical.center,
                    controller: _categoryController,
                    readOnly: true,
                    onTap: _showCategoryPicker,
                    decoration:
                        AppDecorations.borderlessInputDecoration(
                          context,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.folder_outlined,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            onPressed: _showCategoryPicker,
                          ),
                        ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spacingMedium),
              Expanded(
                child: ProjectCreationFormField(
                  label: 'Deadline',
                  hasSuffixIcon: true,
                  childField: TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlignVertical: TextAlignVertical.center,
                    controller: _deadlineController,
                    readOnly: true,
                    onTap: _selectDeadline,
                    decoration:
                        AppDecorations.borderlessInputDecoration(
                          context,
                        ).copyWith(
                          suffixIcon: _selectedDate != null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                  onPressed: _clearDeadline,
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                  onPressed: _selectDeadline,
                                ),
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectCreationFormField(
            label: 'Tags',
            hasBorder: false,
            childField: TextFormField(
              controller: _tagsController,
              readOnly: true,
              style: Theme.of(context).textTheme.bodyMedium,
              cursorColor: Theme.of(context).colorScheme.outline,
              decoration: AppDecorations.borderlessInputDecoration(context),
            ),
            // childField: TagsInputField(
            //   selectedTags: _selectedTags,
            //   onTagsChanged: (tags) {
            //     setState(() {
            //       _selectedTags = tags;
            //     });
            //     print('Tags changed: $tags');
            //   },
            // ),
          ),
          const SizedBox(height: AppDimens.spacingMedium),
          ProjectCreationFormField(
            label: 'Importance',
            childField: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              cursorColor: Theme.of(context).colorScheme.outline,
              decoration: AppDecorations.borderlessInputDecoration(context),
            ),
          ),
        ],
      ),
    );
  }
}
