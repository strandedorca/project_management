import 'package:flutter/material.dart';
import 'package:project_manager/components/button.dart';
import 'package:project_manager/components/customAppbar.dart';
import 'package:project_manager/pages/create_project/projectCreationForm.dart';
import 'package:project_manager/themes/dimens.dart';

class ProjectCreation extends StatefulWidget {
  const ProjectCreation({super.key});

  @override
  State<ProjectCreation> createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation> {
  // Create a global key to uniquely identify the Form widget & enable validation
  // Form key needs to be in parent to access from submit button
  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      // TODO: Create project with form data
      print('Form is valid! Creating project...');
      // Navigator.pop(context); // Go back after creation
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
              'Create New Project',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            leading: Icon(Icons.arrow_back),
            leadingOnTap: () => Navigator.of(context).pop(),
          ),
          // Form
          body: Padding(
            padding: EdgeInsets.all(AppDimens.appPadding),
            // Make the form scrollable
            child: SingleChildScrollView(
              child: ProjectCreationForm(formKey: _formKey),
            ),
          ),
          // Bottom button to submit form
          bottomNavigationBar: _BottomAppBarButton(onPressed: _handleSubmit),
        ),
      ),
    );
  }
}

class _BottomAppBarButton extends StatelessWidget {
  const _BottomAppBarButton({required this.onPressed});

  final VoidCallback onPressed;

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
