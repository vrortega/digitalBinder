import 'package:flutter/material.dart';
import 'dart:io';
import 'photo_card.dart';

class BinderWidget extends StatelessWidget {

  final List<File?> cards;

  const BinderWidget({
    super.key,
    required this.cards,
  });

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
            children: [

              Expanded(
                child: Column(
                  children: [
                    Expanded(child: PhotoCard(image: cards[0])),
                    const SizedBox(height: 16),
                    Expanded(child: PhotoCard(image: cards[1])),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  children: [
                    Expanded(child: PhotoCard(image: cards[2])),
                    const SizedBox(height: 16),
                    Expanded(child: PhotoCard(image: cards[3])),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}