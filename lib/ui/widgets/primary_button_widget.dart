import 'package:flutter/material.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';

class PrimaryButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isDisabled = widget.onPressed == null;

    Widget buttonContent = ElevatedButton(
      onPressed: isDisabled ? null : widget.onPressed,
      onHover: (isHovered) {
        setState(() {
          this._isHovered = isHovered;
        });
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        elevation: WidgetStateProperty.all(5),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return grey500;
          }
          if (states.contains(WidgetState.hovered)) {
            return primary800;
          }
          return Colors.transparent;
        }),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: isDisabled || _isHovered
              ? null
              : LinearGradient(
                  colors: [primaryGradientTop, primaryGradientBottom],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: buttonLarge.copyWith(color: grey100),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: buttonContent,
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: [buttonContent]);
  }
}
