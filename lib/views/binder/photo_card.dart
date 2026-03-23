import 'package:flutter/material.dart';
import 'dart:io';

class PhotoCard extends StatelessWidget {

  final File? image;

  const PhotoCard({
    super.key,
    this.image,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
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
                Icons.image,
                size: 40,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}