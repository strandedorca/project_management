import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

/// A button with a custom padding and border radius
/// By default, this is a rounded button with a medium padding

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.onPressed,
    required this.child,
    this.padding,
    this.borderRadius,
  });
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding:
            padding ?? EdgeInsets.all(AppDimens.paddingMedium), // Inner padding
        shape: AppDecorations.roundedBorderedRectangleBorder(
          context,
          borderRadius ?? 999,
        ),
      ),
      onPressed:
          onPressed ??
          () {
            print('Button pressed');
          },
      child: child,
    );
  }
}
