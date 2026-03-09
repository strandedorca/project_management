import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_manager/app/projects_provider.dart';
import 'package:project_manager/components/modalBottomSheet.dart';
import 'package:project_manager/data/models/option.dart';
import 'package:project_manager/data/models/project.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectDetailOptionsModal extends ConsumerStatefulWidget {
  const ProjectDetailOptionsModal({super.key, required this.project});

  final Project project;

  static Future<void> showModal(BuildContext context, Project project) {
    return ModelBottomSheet.show(
      context,
      ProjectDetailOptionsModal(project: project),
    );
  }

  @override
  ConsumerState<ProjectDetailOptionsModal> createState() =>
      _ProjectDetailOptionsModalState();
}

class _ProjectDetailOptionsModalState
    extends ConsumerState<ProjectDetailOptionsModal> {
  final List<Option> _options = [
    Option.fromValues('delete', 'Delete', Icons.delete_outline),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleDelete() async {
    ref.read(projectsProvider.notifier).delete(widget.project.id);
    print('Project deleted: ${widget.project.id}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _options.length,
      itemBuilder: (context, index) {
        final option = _options[index];

        return ListTile(
          leading: Icon(
            option.icon ?? Icons.folder_outlined,
            color: Theme.of(context).colorScheme.outline,
          ),
          title: Text(
            option.label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          horizontalTitleGap: AppDimens.spacingMedium,
          minLeadingWidth: 0,
          onTap: _handleDelete,
        );
      },
    );
  }
}
