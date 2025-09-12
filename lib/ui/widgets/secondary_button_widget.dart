import 'package:flutter/material.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const SecondaryButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisabled = onPressed == null;

    Widget buttonContent = OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        textStyle: WidgetStateProperty.all(buttonLarge),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return grey500;
          }

          if (states.contains(WidgetState.hovered)) {
            return red600;
          }

          return red300;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.transparent;
          }

          return grey100;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: grey500, width: 2.0);
          }

          if (states.contains(WidgetState.hovered)) {
            return BorderSide(color: red600, width: 2.0);
          }

          return BorderSide(color: red300, width: 1.4);
        }),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        alignment: Alignment.center,
        child: child,
      ),
    );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: buttonContent);
    }

    return Row(mainAxisSize: MainAxisSize.min, children: [buttonContent]);
  }
}
