import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class Button extends StatelessWidget {
  const Button({super.key, this.onPressed, required this.child});
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.all(AppDimens.paddingMedium), // Inner padding
        shape: AppDecorations.roundedBorderedRectangleBorder(context, 999),
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
