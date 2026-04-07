import 'package:flutter/material.dart';
import 'dart:io';
import '../../theme/app_colors.dart';

class PhotoCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(10),
              image: image != null
                  ? DecorationImage(
                      image: FileImage(image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: image == null
                ? const Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),

          if (isFavorite)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}