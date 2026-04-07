import 'package:flutter/material.dart';
import 'dart:io';
import '../../theme/app_colors.dart';

class PhotoCard extends StatefulWidget {
  final File? image;
  final bool isFavorite;
  final VoidCallback onTap;

  const PhotoCard({
    super.key,
    this.image,
    required this.onTap,
    this.isFavorite = false,
  });

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulse = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant PhotoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFavorite && !oldWidget.isFavorite) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(10),
              image: widget.image != null
                  ? DecorationImage(
                      image: FileImage(widget.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.image == null
                ? const Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),

          Positioned(
            top: 5,
            right: 5,
            child: AnimatedOpacity(
              opacity: widget.isFavorite ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: 1 + (_glow.value * 1.5),
                        child: Opacity(
                          opacity: (1 - _glow.value) * 0.6,
                          child: const Icon(
                            Icons.star,
                            size: 30,
                            color: AppColors.background,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.star,
                        size: 30,
                        color: AppColors.background
                            .withValues(alpha: 0.3 + (_glow.value * 0.3)),
                      ),

                      Transform.scale(
                        scale: widget.isFavorite ? _pulse.value : 1,
                        child: const Icon(
                          Icons.star,
                          size: 20,
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}