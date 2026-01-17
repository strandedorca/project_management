import 'package:flutter/material.dart';
import 'package:project_manager/themes/dimens.dart';

class Section extends StatelessWidget {
  final Widget body;
  const Section({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Takes only needed space
      children: [
        // Title & See All button
        // TODO: Style title and button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // TODO: Add a See All button that navigates to the projects page
          children: [Text('Ongoing Projects'), Text('See All')],
        ),
        SizedBox(height: AppDimens.spacingSmall),
        body,
      ],
    );
  }
}
