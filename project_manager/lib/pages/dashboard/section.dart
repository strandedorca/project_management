import 'package:flutter/material.dart';
import 'package:project_manager/themes/colors.dart';
import 'package:project_manager/themes/dimens.dart';

class Section extends StatelessWidget {
  final Widget body;
  final String title;
  const Section({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // TODO: Add a See All button that navigates to the projects page
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                'See All',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimens.spacingMedium),
        body,
      ],
    );
  }
}
