import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class ModelBottomSheet extends StatelessWidget {
  const ModelBottomSheet({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  static Future<dynamic> show(BuildContext context, String title, Widget body) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: AppDecorations.roundedBorderedRectangleBorder(
        context,
        AppDimens.borderRadiusMedium,
      ),
      builder: (context) {
        return ModelBottomSheet(title: title, body: body);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppDimens.appPadding),
          decoration: AppDecorations.bottomBorderedBoxDecoration(context),
          width: double.infinity,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: body,
          ),
        ),
        // const SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}
