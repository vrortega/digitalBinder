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

    _pulse = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant PhotoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final becameFavorite = widget.isFavorite && !oldWidget.isFavorite;

    if (becameFavorite && mounted) {
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
    return AspectRatio(
      aspectRatio: 5 / 7, 
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: widget.image != null
                    ? Image.file(
                        widget.image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add_photo_alternate,
                          size: 36,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            Positioned(
              top: 6,
              right: 6,
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
                          scale: 1 + (_glow.value * 1.8),
                          child: Opacity(
                            opacity: (1 - _glow.value) * 0.5,
                            child: const Icon(
                              Icons.star,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.star,
                          size: 28,
                          color: Colors.white.withValues(
                            alpha: 0.3 + (_glow.value * 0.3),
                          ),
                        ),

                        Transform.scale(
                          scale: widget.isFavorite ? _pulse.value : 1,
                          child: const Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.white,
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
      ),
    );
  }
}