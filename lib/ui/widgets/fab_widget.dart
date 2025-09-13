import 'package:flutter/material.dart';
import 'package:goods/ui/theme/colors.dart';

class PrimaryFab extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const PrimaryFab({super.key, this.onPressed, required this.child});

  @override
  State<PrimaryFab> createState() => _PrimaryFabState();
}

class _PrimaryFabState extends State<PrimaryFab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;

    // detect hover state
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: !isDisabled && !_isHovered
              ? LinearGradient(
                  // normal state
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryGradientTop, primaryGradientBottom],
                )
              : null,
          color: isDisabled
              ? grey500 // disable state
              : _isHovered
              ? primary800 // hover state
              : null,
        ),
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: Colors.transparent,
          // make FAB background transparent to show gradient
          elevation: 0,
          highlightElevation: 0,
          child: widget.child,
        ),
      ),
    );
  }
}
