import 'package:flutter/material.dart';
import 'package:project_manager/themes/dimens.dart';

class Section extends StatelessWidget {
  final Widget body;
  final String title;
  const Section({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title & See All button
        // TODO: Style title and button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // TODO: Add a See All button that navigates to the projects page
          children: [Text(title), Text('See All')],
        ),
        SizedBox(height: AppDimens.spacingMedium),
        body,
      ],
    );
  }
}
