import 'package:flutter/material.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/number_formatter.dart';

class CardProjectProgress extends StatelessWidget {
  final double progress;
  const CardProjectProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress', style: Theme.of(context).textTheme.bodySmall),
            Text(
              NumberFormatter.percentage(progress),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: AppDimens.spacingSmall),

        // Progress bar
        _ProgresBar(progress: progress, height: 14),
      ],
    );
  }
}

class _ProgresBar extends StatelessWidget {
  final double progress;
  final double height;

  const _ProgresBar({required this.progress, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress / 100,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
