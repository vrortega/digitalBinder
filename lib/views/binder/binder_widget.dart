import 'package:flutter/material.dart';

class BinderWidget extends StatelessWidget {
  const BinderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4EFEA),
      child: Center(
        child: Container(
          width: 340,
          height: 420,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7F5),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: const [
              Expanded(child: BinderPage()),
              SizedBox(width: 16),
              Expanded(child: BinderPage()),
            ],
          ),
        ),
      ),
    );
  }
}

class BinderPage extends StatelessWidget {
  const BinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(child: PhotoCard()),
        SizedBox(height: 16),
        Expanded(child: PhotoCard()),
      ],
    );
  }
}

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}