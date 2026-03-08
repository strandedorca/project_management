import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/project_providers.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/pages/projects/projectCreationModel.dart';
import 'package:project_manager/pages/projects/projectDetailForm.dart';
import 'package:project_manager/pages/projects/projectDetailOptionsModal.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectDetail extends ConsumerStatefulWidget {
  const ProjectDetail({super.key, required this.project});

  final Project project;

  @override
  ConsumerState<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends ConsumerState<ProjectDetail> {
  final _formKey = GlobalKey<FormState>();
  late ProjectCreationModel _data;

  @override
  void initState() {
    super.initState();
    _data = ProjectCreationModel.fromProject(widget.project);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    ref
        .read(projectsProvider.notifier)
        .update(_data.toProject(widget.project.id));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final doesExist = projects.any(
      (project) => project.id == widget.project.id,
    );
    // If project somehow disappeared, automatically navigate back
    if (!doesExist) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
    }

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
            trailing: IconButton(
              onPressed: () =>
                  ProjectDetailOptionsModal.showModal(context, widget.project),
              icon: Icon(Icons.more_vert),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(AppDimens.appPadding),
            // Make the form scrollable
            child: SingleChildScrollView(
              child: ProjectDetailForm(formKey: _formKey, data: _data),
            ),
          ),
          bottomNavigationBar: _BottomAppBarButton(
            onPressed: () => _handleSubmit(),
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
      'Update Project',
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
