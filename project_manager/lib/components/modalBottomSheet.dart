import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class ModelBottomSheet extends StatelessWidget {
  const ModelBottomSheet({
    super.key,
    required this.title,
    required this.body,
    this.actionIcon,
  });

  final String title;
  final Widget body;
  final Widget? actionIcon;

  static Future<dynamic> show(
    BuildContext context,
    String title,
    Widget body, {
    Widget? actionIcon,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: AppDecorations.roundedBorderedRectangleBorder(
        context,
        AppDimens.borderRadiusMedium,
      ),
      builder: (context) {
        return ModelBottomSheet(
          title: title,
          body: body,
          actionIcon: actionIcon,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(AppDimens.appPadding),
          decoration: AppDecorations.bottomBorderedBoxDecoration(context),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (actionIcon != null)
                SizedBox(
                  height: AppDimens.iconSmall,
                  width: AppDimens.iconMedium,
                  child: actionIcon!,
                ),
            ],
          ),
        ),
        //  Main content
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
