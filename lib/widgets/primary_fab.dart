import 'package:flutter/material.dart';
import 'package:digital_binder/theme/app_colors.dart';

class PrimaryFab extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const PrimaryFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  State<PrimaryFab> createState() => _PrimaryFabState();
}

class _PrimaryFabState extends State<PrimaryFab> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = isPressed ? 0.92 : 1.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scaleByDouble(scale, scale, 1.0, 1.0),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: isPressed ? 6 : 12,
                offset: Offset(0, isPressed ? 2 : 6),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}