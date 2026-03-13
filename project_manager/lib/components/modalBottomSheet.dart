import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class ModelBottomSheet extends StatelessWidget {
  const ModelBottomSheet({
    super.key,
    this.title,
    required this.body,
    this.iconData,
    this.onIconPressed,
  });

  final String? title;
  final Widget body;
  final IconData? iconData;
  final VoidCallback? onIconPressed;

  static Future<void> show(
    BuildContext context,
    Widget body, {
    IconData? iconData,
    String? title,
    VoidCallback? onIconPressed,
  }) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: AppDimens.borderWidthMedium),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.borderRadiusMedium),
          topRight: Radius.circular(AppDimens.borderRadiusMedium),
        ),
      ),
      builder: (context) {
        return ModelBottomSheet(
          title: title,
          body: body,
          iconData: iconData,
          onIconPressed: onIconPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        if (title != null)
          Container(
            decoration: AppDecorations.bottomBorderedBoxDecoration(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.primary),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDimens.appPadding),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (iconData != null)
                  InkWell(
                    onTap: onIconPressed,
                    child: Padding(
                      padding: EdgeInsets.all(AppDimens.paddingMedium),
                      child: Icon(iconData!, size: AppDimens.iconMedium),
                    ),
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
      ],
    );
  }
}
