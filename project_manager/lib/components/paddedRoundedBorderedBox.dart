import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class PaddedRoundedBorderedBox extends StatelessWidget {
  const PaddedRoundedBorderedBox({
    super.key,
    this.padding,
    this.borderRadius = AppDimens.borderRadiusSmall,
    required this.child,
  });

  final EdgeInsets? padding;
  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.roundedBorderedBox(context, borderRadius),
      padding: padding ?? EdgeInsets.all(AppDimens.paddingMedium),
      child: child,
    );
  }
}
