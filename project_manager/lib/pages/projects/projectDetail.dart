import 'package:flutter/material.dart';
import 'package:project_manager/app/dependencies.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/pages/projects/projectCreationModel.dart';
import 'package:project_manager/pages/projects/projectDetailForm.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({super.key, required this.project});

  final Project project;

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  final _formKey = GlobalKey<FormState>();
  late final ProjectCreationModel _data = ProjectCreationModel.fromProject(
    widget.project,
  );
  bool _loading = false;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save(); // triggers all onSaved → _data is fully updated

    setState(() => _loading = true);

    try {
      await Future.delayed(Duration(seconds: 1)); // fake API
      projectService.updateProject(_data.toProject(widget.project.id));

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(
              widget.project.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            leading: Icon(Icons.arrow_back),
            leadingOnTap: () => Navigator.of(context).pop(),
          ),
          body: Padding(
            padding: EdgeInsets.all(AppDimens.appPadding),
            // Make the form scrollable
            child: SingleChildScrollView(
              child: ProjectCreationForm(
                formKey: _formKey,
                data: _data,
              ),
            ),
          ),
          bottomNavigationBar: _BottomAppBarButton(
            onPressed: _loading ? null : _handleSubmit,
          ),
        ),
      ),
    );
  }
}

class _BottomAppBarButton extends StatelessWidget {
  const _BottomAppBarButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget buttonText = Text(
      'Create Project',
      style: Theme.of(context).textTheme.titleMedium,
    );

    return BottomAppBar(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(AppDimens.paddingLarge),
        child: Button(onPressed: onPressed, child: buttonText),
      ),
    );
  }
}
