import 'package:flutter/material.dart';
import 'package:project_manager/themes/dimens.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Progress'), Text(progress.toString())],
        ),
        SizedBox(height: AppDimens.spacingSmall),
        // TODO: Implement the progress bar
        Container(
          width: double.infinity,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          ),
        ),
      ],
    );
  }
}
